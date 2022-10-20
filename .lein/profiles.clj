{:repl {:plugins [[refactor-nrepl "3.5.2"]
                  [cider/cider-nrepl "0.28.3"] ]}
 :user {:dependencies [[borkdude/jet "0.0.6"]]
        :aliases {"jet" ["run" "-m" "jet.main"]}
        :plugins [[lein-ns-dep-graph "0.4.0-SNAPSHOT"]]} }
