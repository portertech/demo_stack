(ns demo_stack.riak
  (:use demo_stack.graphite)
  (:require [clojurewerkz.welle.core :as wc]
            [clojurewerkz.welle.buckets :as wb]
            [clojurewerkz.welle.kv :as kv])
  (:import com.basho.riak.client.http.util.Constants))

(wc/connect!)
(wb/create "demo_stack")

(defn store [key value]
  (let [start (System/currentTimeMillis)
        _ (kv/store "demo_stack" key value :content-type Constants/CTYPE_JSON_UTF8)
        finish (System/currentTimeMillis)
        time (- finish start)]
    (metric "api.riak.store.time" time)))

(defn fetch [key]
  (let [start (System/currentTimeMillis)
        [response] (kv/fetch "demo_stack" key)
        finish (System/currentTimeMillis)
        time (- finish start)]
    (metric "api.riak.fetch.time" time)
    (:value response)))

(defn delete [key]
  (let [start (System/currentTimeMillis)
        _ (kv/delete "demo_stack" key)
        finish (System/currentTimeMillis)
        time (- finish start)]
    (metric "api.riak.delete.time" time)))
