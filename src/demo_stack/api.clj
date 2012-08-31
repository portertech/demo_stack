(ns demo_stack.api
  (:use demo_stack.middleware
        ring.adapter.jetty)
  (:require [clojure.string :as string]
            [cheshire.core :as json]
            [demo_stack.riak :as riak])
  (:import java.util.UUID)
  (:gen-class))

(defn not-found
  ([request]
  (let [message "This is not the page you are looking for."]
    (not-found request (json/generate-string {:error message}))))
  ([request body]
  {:status 404 :body body}))

(defn favicon [request]
  (not-found request ""))

(defn pong [request]
  (riak/ping)
  {:status 200
   :body (json/generate-string {:message "pong"})})

(defn self-destruct [request]
  (throw (Exception. "BOOM!")))

(defn create-contact [request]
  (let [details (json/parse-string (slurp (:body request)) true)
        id (str (UUID/randomUUID))]
    (riak/store id details)
    {:status 201
     :body (json/generate-string {:id id})}))

(defn get-contact [request]
  (let [id (last (string/split (:uri request) #"/"))]
    (let [details (riak/fetch id)]
      (if (nil? details)
        (not-found request "")
        {:status 200
         :body (json/generate-string details)}))))

(defn delete-contact [request]
  (let [id (last (string/split (:uri request) #"/"))]
    (riak/delete id)
    {:status 204 :body ""}))

(defn router [request]
  (condp = (second (string/split (:uri request) #"/"))
   "favicon.ico"
     (favicon request)
   "ping"
     (pong request)
   "fail"
     (self-destruct request)
   "contacts"
     (condp = (:request-method request)
       :post
         (create-contact request)
       :get
         (get-contact request)
       :delete
         (delete-contact request)
       (not-found request))
   (not-found request)))

(def api
  (-> #'router
    (wrap-exception-logging)
    (wrap-failsafe)
    (wrap-content-type)
    (wrap-request-logging)))

(defn -main []
  (let [port (Integer/parseInt (get (System/getenv) "PORT" "3000"))]
    (run-jetty api {:port port})))
