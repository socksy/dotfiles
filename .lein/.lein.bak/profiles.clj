{:user {:plugins [[cider/cider-nrepl "0.20.0-SNAPSHOT"]
                  [refactor-nrepl "2.4.0-SNAPSHOT"]
                  [lein-difftest "2.0.0"]
                  [lein-environ "1.0.3"]
                  [lein-kibit "0.1.2"]
                  [lein-licenses "0.2.1"]]
        :dependencies [[alembic "0.3.2"]
                       [org.clojure/tools.nrepl "0.2.12"]
                       [org.tcrawley/dynapath "0.2.3"]
                       [org.clojure/tools.namespace "0.2.7"]]
        :source-paths ["/home/ben/.lein/src"]
        :repl-options { :init-ns user }}}