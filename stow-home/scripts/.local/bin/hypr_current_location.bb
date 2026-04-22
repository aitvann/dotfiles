; vim: set ft=clojure:

(ns hypr-current-location)

(require '[babashka.cli :as cli]
         '[babashka.process :refer [sh]]
         '[cheshire.core :as json])

(defn write-current-location [name location pids nvim-pipe]
  (let [nvim-pipe (if nvim-pipe ["--nvim-pipe" nvim-pipe] [])]
    (apply sh "current-location" "writee" name location (concat pids nvim-pipe))))

(defn get-data []
  (-> (sh "current-location" "get")
      :out
      (json/parse-string true)))

(defn clear []
  (sh "current-location" "clear"))

(defn get-cmd [_m]
  (println (json/generate-string (get-data))))
(defn write-cmd [{:keys [args opts]}]
  (let [[name location & pids] args
        {:keys [nvim-pipe]} opts]
    (write-current-location name location pids nvim-pipe)))
(defn clear-cmd [_m] (clear))

(def table [{:cmds ["get"]            :fn get-cmd}
            {:cmds ["write"]          :fn write-cmd}
            {:cmds ["clear"]          :fn clear-cmd}])

; (cli/dispatch table *command-line-args*)
(defn -main [& args]
  (cli/dispatch table args))
