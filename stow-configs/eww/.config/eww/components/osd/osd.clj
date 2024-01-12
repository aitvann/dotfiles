#! /usr/bin/env bb

(require '[babashka.cli :as cli]
         '[clojure.java.shell :as shell :refer [sh]]
         '[cheshire.core :as json]
         '[clojure.string :as str])

(def interval-ms 1000) ; 1 sec

(defn eww-update [key value]
  (sh "xargs" "-d" " " "eww" :in (str "update " key "=" value)))

(defn osd-open? []
  (->> (sh "eww" "windows")
       :out
       str/split-lines
       (filter #(= % "*osd"))
       seq
       boolean))

(defn run [icon value]
  (eww-update "osd" (json/generate-string {:icon icon :value value}))
  (eww-update "osd_time" (System/currentTimeMillis))

  (when (not (osd-open?))
    (sh "eww" "open" "osd")
    (loop []
      (Thread/sleep interval-ms)
      (let [start-time (-> (sh "eww" "get" "osd_time")
                           :out
                           str/trim
                           Long/parseLong)
            current-time (System/currentTimeMillis)
            elapsed-time (- current-time start-time)]
        (if (>= elapsed-time interval-ms)
          (sh "eww" "close" "osd")
          (recur))))))

(let [{[icon value] :args} (cli/parse-args *command-line-args*)]
  (run icon value))

