(ns demo_stack.logger)

(defn log [message & values]
  (let [line (apply format message values)]
    (locking System/out (println line))))
