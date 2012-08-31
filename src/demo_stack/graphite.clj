(ns demo_stack.graphite
  (:require [clojure.tools.logging :as log]
            [clojure.java.io :as io])
  (:import [java.net Socket]))

(defn- graphite-host []
  (get (System/getenv) "GRAPHITE_HOST" "127.0.0.1"))

(defn- write-metric [name value timestamp]
  (try
    (with-open [socket (Socket. (graphite-host) 2003)
                writer (io/writer (.getOutputStream socket))]
        (.write writer (format "%s %d %d\n" name value timestamp)))
    (catch Exception error
      (log/error error "failed to write to graphite"))))

(defn- now []
  (int (/ (System/currentTimeMillis) 1000)))

(defn store
  ([name value]
  (future (write-metric name value (now))))
  ([name value timestamp]
  (future (write-metric name value timestamp))))
