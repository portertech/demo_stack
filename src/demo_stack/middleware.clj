(ns demo_stack.middleware
  (:use demo_stack.logger)
  (:use demo_stack.graphite)
  (:require [clj-stacktrace.repl :as stacktrace]))

(defn wrap-exception-logging [handler]
  (fn [request]
    (try
      (handler request)
      (catch Exception error
        (log "exception:\n%s" (stacktrace/pst-str error))
        (throw error)))))

(defn wrap-failsafe [handler]
  (fn [request]
    (try
      (handler request)
      (catch Exception error
        {:status 500
         :headers {"Content-Type" "text/plain"}
         :body "something went wrong!"}))))

(defn request-metrics [raw-method raw-uri status time]
  (let [method (subs (str raw-method) 1)
        uri (clojure.string/replace (subs raw-uri 1) #"[^\w.-]" "_")]
    (metric (format "api.request.%s.%s.time" method uri) time)
    (metric (format "api.request.%s.%d" method status) 1)))

(defn wrap-request-logging [handler]
  (fn [request]
    (let [start (System/currentTimeMillis)
          response (handler request)
          finish (System/currentTimeMillis)
          time (- finish start)]
      (log "request %s %s %d (%dms)" (:request-method request) (:uri request) (:status response) time)
;      (request-metrics (:request-method request) (:uri request) (:status response) time)
      response)))
