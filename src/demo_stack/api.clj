(ns demo_stack.api
  (:use demo_stack.middleware)
  (:use ring.adapter.jetty))

(defn not_found [request]
  {:status 404
   :headers {"Content-Type" "text/html"}
   :body "are you lost?"})

(defn favicon [request]
  {:status 404
   :headers {}
   :body ""})

(defn pong [request]
  (Thread/sleep (rand-int 100))
  {:status 200
   :headers {"Content-Type" "text/html"}
   :body "pong"})

(defn fail [request]
  (throw (Exception. "self destruction!")))

(defn router [request]
  (condp = (:uri request)
   "/favicon.ico"
     (favicon request)
   "/ping"
     (pong request)
   "/fail"
     (fail request)
   (not_found request)))

(def api
  (-> #'router
    (wrap-exception-logging)
    (wrap-failsafe)
    (wrap-request-logging)))

(defn -main []
  (run-jetty api {:port 3000}))
