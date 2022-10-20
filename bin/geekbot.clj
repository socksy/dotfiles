#!/usr/bin/env bb
(ns geekbot
  (:require [babashka.curl as curl]
            [clojure.java.shell :refer [sh]]
            [clojure.string :as str]))

(def gcaltomorrow
  (let [results (sh "gcalcli" "agenda" "tomorrow" "next" "2" "days" "--tsv")]
    (if (= 0 (:exit results))
      (map #(->> %
                 (str/split #"\n")
                 (str/split #"\t")
                 last)
           (:out results))
      (do (println "Failed to get `gcalcli agenda` to work")
          (println (:err results))
          (System/exit 1)))))

(defn events-includes [include-str event-names]
  (some #(.contains % include-str) event-names))

(defn create-report
  [event-names]
  (let [includes? #(events-includes % event-names)]
      (cond-> {}
        (includes? "Appointment")
        (assoc :doc-appointment true)
        (includes? "Ben / Phil")
        (assoc :phil-1-1 true)
        (includes? "Ben / John")
        (assoc :john-1-1 true)
        (> 1 (count (filter #(or (.contains % "Appointment")
                                 (.contain % "No meetings"))
                            event-names)))
        (assoc :meetings true))))
