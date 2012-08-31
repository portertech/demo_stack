(defproject demo_stack "1.0.0-SNAPSHOT"
  :description "Demo stack application for a Polyglot Vancouver presentation."
  :dependencies [[org.clojure/clojure "1.4.0"]
                 [log4j/log4j "1.2.17"]
                 [org.clojure/tools.logging "0.2.3"]
                 [cheshire "4.0.1"]
                 [com.novemberain/welle "1.1.1"]
                 [ring "1.1.1"]]
  :resources-path "etc"
  :main demo_stack.api)
