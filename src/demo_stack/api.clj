(ns demo_stack.api
  (:use demo_stack.middleware
        demo_stack.riak
        cheshire.core
        ring.adapter.jetty)
  (:require [clojure.string :as string])
  (:import java.util.UUID))

(defn not-found
  ([request]
  (let [message "This is not the page you are looking for."]
    (not-found request (generate-string {:error message}))))
  ([request body]
  {:status 404 :body body}))

(defn favicon [request]
  (not-found request ""))

(defn pong [request]
  (ping-riak)
  {:status 200
   :body (generate-string {:message "pong"})})

(defn self-destruct [request]
  (throw (Exception. "self destruction!")))

(defn create-contact [request]
  (let [body (parse-string (slurp (:body request)) true)
        id (str (UUID/randomUUID))]
    (store id body)
    {:status 201
     :body (generate-string {:id id})}))

(defn get-contact [request]
  (let [id (last (string/split (:uri request) #"/"))]
    (let [body (fetch id)]
      (if (nil? body)
        (not-found request "")
        {:status 200
         :body (generate-string body)}))))

(defn delete-contact [request]
  (let [id (last (string/split (:uri request) #"/"))]
    (delete id)
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
  (run-jetty api {:port 3000}))
