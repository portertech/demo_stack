(ns demo_stack.riak
  (:require [clojurewerkz.welle.core :as wc]
            [clojurewerkz.welle.buckets :as wb]
            [clojurewerkz.welle.kv :as kv])
  (:import com.basho.riak.client.http.util.Constants))

(wc/connect!)
(wb/create "demo_stack")

(defn store [key value]
  (kv/store "demo_stack" key value :content-type Constants/CTYPE_JSON_UTF8))

(defn fetch [key]
  (let [[response] (kv/fetch "demo_stack" key)]
    (:value response)))

(defn destroy [key]
  (kv/delete "demo_stack" key))
