; vim: set ft=clojure:

(ns hypr-current-location)

(require '[babashka.cli :as cli]
         '[babashka.process :refer [sh]]
         '[cheshire.core :as json])

(defn write-current-location [name pid location nvim_pipe]
  (if nvim_pipe
    (sh "current-location write" name pid location nvim_pipe)
    (sh "current-location write" name pid location)))

(defn get-data []
  (-> (sh "current-location get")
      :out
      (json/parse-string true)))

(defn clear []
  (sh "current-location clear"))

(defn get-cmd [_m]
  (println (json/generate-string (get-data))))
(defn write-cmd [{:keys [args]}]
  (let [[name pid location nvim_pipe] args]
    (write-current-location name pid location nvim_pipe)))
(defn clear-cmd [_m] (clear))

(def table [{:cmds ["get"]            :fn get-cmd}
            {:cmds ["write"]          :fn write-cmd}
            {:cmds ["clear"]          :fn clear-cmd}])

; (cli/dispatch table *command-line-args*)
(defn -main [& args]
  (cli/dispatch table args))
