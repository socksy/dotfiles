#!/usr/bin/env bb

(ns zenhub
  (:require [babashka.curl :as curl]
            [babashka.deps :as deps]
            [babashka.fs :as fs]
            [cheshire.core :as json]
            [clojure.java.shell :refer [sh]]
            [clojure.string :as str]
            [clojure.tools.cli :refer [parse-opts]]))

(deps/add-deps
 '{:deps {io.aviso/pretty {:mvn/version "1.1"}}})
(require '[io.aviso.ansi :as ansi])
(require '[io.aviso.columns :as cols])

;; Utils
(def zenhub-token (try (str/trim-newline (slurp ".zenhub_token"))
                       (catch Exception e
                         (println "Couldn't find the zenhub token (https://app.zenhub.com/dashboard/tokens) at pitch-app/.zenhub_token")
                         (System/exit 1))))

(def api-endpoint "https://api.zenhub.com/p1/repositories/110549400")
(def pitch-app-workspace-id "5ac753f4f41bfa50c0e498e7")
(def api2-endpoint (str "https://api.zenhub.com/p2/workspaces/" pitch-app-workspace-id
                        "/repositories/110549400"))

(defn zenhub-api-call [method route opts]
  (let [api-endpoint (if (:p2 opts) api2-endpoint api-endpoint)
        opts (dissoc opts :p2)]
   (method (str api-endpoint route)
           (assoc opts :headers (merge {"X-Authentication-Token" zenhub-token
                                        "Accept" "application/json"
                                        "Content-Type" "application/json"}
                                       (:headers opts))))))

(defn getz
  ([route] (getz route {}))
  ([route opts] 
   (zenhub-api-call curl/get route opts)))

(def getz-memoized (memoize getz))

(defn postz
  ([route] (postz route {}))
  ([route opts]
  (zenhub-api-call curl/post route opts)))

(defn sh-or-exit
  [& args]
  (let [results (apply sh args)]
    (if (= 0 (:exit results))
      (:out results)
      (do (println ansi/bold-red-font "Failed to run command " (str/join " " args) ansi/reset-font)
          (println (:err results))
          (System/exit 1)))))


;; For board/listing
(defn team-name [options]
  (or (:team-name options)
      (System/getenv "ZENHUB_TEAM_NAME")
      "Team Platform"))

(defn team-issues
  [team-name]
  (let [team-issues-gh-shell (sh "gh" "issue" "list" "--json" "id,number,title,body,labels,assignees" "-l" team-name :env (assoc (into {} (System/getenv)) "GH_REPO" "pitch-io/pitch-app"))]
    (if (= 0 (:exit team-issues-gh-shell))
      (json/parse-string (:out team-issues-gh-shell)
                         true)
      (do (println "Failed to run gh command to get team issues. Have you set it up locally?")
          (println (:err team-issues-gh-shell))
          (System/exit 1)))))

(def team-issues-memoized (memoize team-issues))

(def board (:pipelines (json/parse-string (:body (getz-memoized "/board")) true)))

(defn issue-numbers [pipeline-name] 
  (->> board
       (filter #(= pipeline-name (:name %)))
       first
       :issues
       (map :issue_number)))

(def pipeline-column->name
  {"next" "Next"
   "new" "New Issues"
   "in-progress" "In Progress"
   "backlog" "Backlog"
   "qa" "Review/QA"
   "review" "Review/QA"
   "closed" "Closed"})

(defn pipeline-issues
  [team-name pipeline-name]
  (let [pipeline-name (or (pipeline-column->name pipeline-name) pipeline-name)
        pipeline-set (into #{} (issue-numbers pipeline-name))]
    (filter #(pipeline-set (:number %))
            (team-issues-memoized team-name))))

(defn labels->font-colour
  [labels]
  (let [label-names (set (map :name labels))]
    (cond
      (label-names "Important") ansi/bold-red-font
      (label-names "Bug") ansi/red-font
      (label-names "Improvement") ansi/blue-font
      (label-names "Epic") ansi/yellow-font
      :else ansi/green-font)))

(defn number [{:keys [labels number]}]
  (str (labels->font-colour labels) "[" number "]" ansi/reset-font))

(defn assignees [issue]
  (if (some #(= "Epic" (:name %)) (:labels issue))
    (ansi/yellow-bg (ansi/black "(epic)"))
    (ansi/magenta (str/join ", " (mapv :login (:assignees issue))))))

(defn max-length-of-all-issues
  [team-name value-name]
  (cols/max-value-length (team-issues-memoized team-name) value-name))

(defn list-issues [team-name pipeline-name edn?]
  (let [issues (pipeline-issues team-name pipeline-name)]
    (if edn? 
      (prn {:pipeline pipeline-name :issues (into [] issues)})
      (do (println (ansi/bold pipeline-name))
          (cols/write-rows [number
                            " "
                            [:title :left (min (max-length-of-all-issues team-name :title) 140)]
                            [assignees :right (min (max-length-of-all-issues team-name assignees) 20)]]
                           issues)))))

(defn board-of-team [team-name edn?]
  (list-issues team-name "New Issues" edn?)
  (list-issues team-name "Next" edn?)
  (list-issues team-name "In Progress" edn?)
  (list-issues team-name "Review/QA" edn?))

;; Starting a PR
(defn assign-issue [issue-number]
  (println (ansi/blue (str "Assigning issue " issue-number " to yourself...")))
  (sh-or-exit "gh" "issue" "edit" issue-number "--add-assignee" "@me"))

(def in-progress-pipeline-id "Z2lkOi8vcmFwdG9yL1BpcGVsaW5lLzEzMDQzNDc")

(defn move-to-in-progress [issue-number]
  (println (ansi/blue (str "Moving issue " issue-number " to In Progress...")))
  (spit ".issue-in-progress" issue-number)
  (postz (str "/issues/" issue-number "/moves")
         {:p2 true
          :body (json/generate-string
                 {"pipeline_id" in-progress-pipeline-id
                  "position" "bottom"})}))

(def review-qa-pipeline-id "Z2lkOi8vcmFwdG9yL1BpcGVsaW5lLzEzMDQ0MzE")

(defn move-to-review []
  (when-let [issue-number (str/trim-newline (slurp ".issue-in-progress"))]
    (fs/delete-on-exit ".issue-in-progress")
    (println (ansi/blue (str "Moving issue " issue-number " to Review/QA...")))
    (postz (str "/issues/" issue-number "/moves")
           {:p2 true
            :body (json/generate-string
                   {"pipeline_id" review-qa-pipeline-id
                    "position" "bottom"})})))

(defn git-repo-clean?
  []
  (= 0 (count (:out (sh "git" "status" "--porcelain" "--untracked-files=no")))))

(defn git-stash-if-needed
  []
  (when-not (git-repo-clean?)
    (println "You local git repo is currently unclean. Do you want to stash changes and continue?")
    (print "[y/n]: ")
    (flush)
    (if-not (= (read-line) "y")
      (do (println "Aborting.")
          (System/exit 1))
      (sh-or-exit "git" "stash" "push" "-m" "WIP (automatic stash from zenhub script)"))))

(defn get-issue [issue-number]
  (json/parse-string (sh-or-exit "gh" "issue" "view" issue-number "--json" "title,body") true))

(defn create-pr [issue-number branch-name]
  (let [current-user (System/getenv "USER")
        full-branch-name (str current-user "/" issue-number
                              (when (seq branch-name)
                                (str "-" (first (str/split branch-name #" ")))))
        issue-title (:title (get-issue issue-number))
        [_ first-letter rest-title] (re-find #"\[.*\] (.)(.*)" issue-title)
        pr-title (str "Fix " (str/lower-case first-letter) rest-title)]

    (println (ansi/blue "Pulling latest master..."))
    (sh-or-exit "git" "checkout" "master")
    (sh-or-exit "git" "pull")

    (println (ansi/blue "Creating and pushing new branch to origin..."))
    (when-not (= 0 (:exit (sh "git" "checkout" "-b" full-branch-name)))
      (sh-or-exit "git" "checkout" full-branch-name))

    (sh-or-exit "git" "commit" "--allow-empty" "-m" "Placeholder commit")
    (spit ".commit-to-delete" (sh-or-exit "git" "rev-parse" "HEAD"))
    (sh-or-exit "git" "push")

    (println (ansi/blue "Creating new PR:"))
    (sh-or-exit "gh" "pr" "create" "--assignee" "@me" "--title" pr-title
                "--body" (str "Resolves #" issue-number) "--draft")))

(defn start-issue [issue-number branch-name]
  (git-stash-if-needed)
  (assign-issue issue-number)
  (move-to-in-progress issue-number)
  (create-pr issue-number branch-name))

(defn ready-for-review []
  (git-stash-if-needed)
  (let [branch (str/trim-newline (sh-or-exit "git" "branch" "--show-current"))
        commit-to-delete (str/trim-newline (slurp ".commit-to-delete"))
        _ (if (seq commit-to-delete) (fs/delete-on-exit ".commit-to-delete"))]
    (when (= "master" branch)
      (println "You're on the master branch! Aborting.")
      (System/exit 1))
    ;; Removes the placeholder commit by rebasing the commits after it on to the one before
    (when (seq commit-to-delete)
      (sh-or-exit "git" "rebase" "--onto" (str commit-to-delete "^") commit-to-delete branch)
      (sh-or-exit "git" "push" "--force-with-lease"))
    (sh-or-exit "gh" "pr" "ready" branch)
    (if (= 200 (:status (move-to-review)))
      (println "Ready for review!"))))


(defn usage [summary]
  (println "zenhub cli tool\n")
  (println "To use, set up the gh cli tool and a zenhub API token")
  (println "from the zenhub website, and store in .zenhub_token\n")
  (println "Usage: zenhub [options]\n")
  (println "Options:")
  (println summary))

(def parsed-options
  (parse-opts *command-line-args*
              [["-t" "--team-name NAME" "Select the team to show the board of"]
               ["-b" "--board" "Show the entire board for the selected team"
                :default false]
               ["-p" "--pipeline PIPELINE" "Pipeline, one of next/new/in-progress (for use with --list)"
                :default "next"
                :parse-fn #(or (pipeline-column->name %) %)]
               ["-s" "--start ISSUE NUMBER" "Start working on ISSUE NUMBER"]
               ["-n" "--branch-name NAME" "e.g. name-of-branch, without prefixes (for use with --start)" :default ""]
               ["-r" "--review" "Make the current PR ready for review"]
               ["-l" "--list" "List all issues in the pipeline"]
               [nil "--edn" "Output pipelines as edn"]
               ["-h" "--help" "Show this text"]]))

(if-not (seq (:errors parsed-options))
  (let [options (:options parsed-options)]
    (cond
      (:board options) (board-of-team (team-name options) (:edn options))
      (:list options) (list-issues (team-name options) (:pipeline options) (:edn options))
      (:start options) (print (start-issue (:start options) (:branch-name options)))
      (:review options) (ready-for-review)
      (:help options) (usage (:summary parsed-options))
      :else (usage (:summary parsed-options))))
  (do (println (:errors parsed-options))
      (println (:summary parsed-options))))
