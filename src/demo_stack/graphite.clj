(ns demo_stack.graphite
  (:use demo_stack.logger)
  (:require [clj-stacktrace.repl :as stacktrace]
            [clojure.java.io :as io])
  (import [java.net Socket]))

(defn- write-metric [name value timestamp]
  (try
    (with-open [socket (Socket. "127.0.0.1" 2003)
                reader (io/reader (.getInputStream socket))
                writer (io/writer (.getOutputStream socket))]
        (.write writer (format "%s %d %d\n" name value timestamp)))
    (catch Exception error
      (log "exception:\n%s" (stacktrace/pst-str error)))))

(defn now []
  (int (/ (System/currentTimeMillis) 1000)))

(defn metric
  ([name value]
  (future (write-metric name value (now))))
  ([name value timestamp]
  (future (write-metric name value timestamp))))
