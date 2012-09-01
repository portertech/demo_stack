(ns demo_stack.middleware
  (:require [clojure.tools.logging :as log]
            [clojure.string :as string]
            [cheshire.core :as json]
            [demo_stack.graphite :as graphite]))

(defn exception-logging [handler]
  (fn [request]
    (try
      (handler request)
      (catch Exception error
        (log/error error "failed to complete a request")
        (throw error)))))

(defn failsafe [handler]
  (fn [request]
    (try
      (handler request)
      (catch Exception error
        {:status 500
         :body (json/generate-string {:error (str error)})}))))

(defn content-type [handler]
  (fn [request]
    (let [response (handler request)]
      (assoc-in response [:headers "Content-Type"] "application/json"))))

(defn- record-request [method uri status time]
  (log/infof "request %s %s %d (%dms)" method uri status time)
  (let [resource (second (string/split uri #"/"))]
    (graphite/store (format "api.request.%s.%s.time" resource (name method)) time)
    (graphite/store (format "api.request.%s.%s.%d" resource (name method) status) 1)))

(defn request-logging [handler]
  (fn [request]
    (let [start (System/currentTimeMillis)
          response (handler request)
          finish (System/currentTimeMillis)
          time (- finish start)]
      (record-request (:request-method request) (:uri request) (:status response) time)
      response)))
