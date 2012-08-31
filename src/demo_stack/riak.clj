(ns demo_stack.riak
  (:require [clojure.tools.logging :as log]
            [clojurewerkz.welle.core :as wc]
            [clojurewerkz.welle.buckets :as wb]
            [clojurewerkz.welle.kv :as kv]
            [demo_stack.graphite :as graphite])
  (:import com.basho.riak.client.http.util.Constants))

(defn- riak-host []
  (get (System/getenv) "RIAK_HOST" "127.0.0.1"))

(wc/connect-via-pb! (riak-host) 8087)

(wb/create "demo_stack")

(defn ping []
  (wc/ping))

(defn- record-operation [operation key time]
  (log/infof "riak :%s %s (%dms)" operation key time)
  (graphite/store (format "api.riak.%s.time" operation) time))

(defn store [key value]
  (let [start (System/currentTimeMillis)
        _ (kv/store "demo_stack" key value :content-type Constants/CTYPE_JSON_UTF8)
        finish (System/currentTimeMillis)
        time (- finish start)]
    (record-operation "store" key time)))

(defn fetch [key]
  (let [start (System/currentTimeMillis)
        [response] (kv/fetch "demo_stack" key)
        finish (System/currentTimeMillis)
        time (- finish start)]
    (record-operation "fetch" key time)
    (:value response)))

(defn delete [key]
  (let [start (System/currentTimeMillis)
        _ (kv/delete "demo_stack" key)
        finish (System/currentTimeMillis)
        time (- finish start)]
    (record-operation "delete" key time)))
