; vim: set ft=clojure:

(ns hypr-current-location)

(import [java.io File])
(require '[babashka.cli :as cli]
         '[clojure.java.shell :as shell :refer [sh]]
         '[clojure.string :as str]
         '[cheshire.core :as json]
         '[babashka.fs :as fs])

(def known-procs #{"zsh" "nvim"})

(def locations-path "/tmp/current-location/")
(when-not (fs/exists? locations-path)
  (fs/create-dir locations-path))

(defn current-pid []
  (:pid (json/parse-string (:out (sh "hyprctl" "activewindow" "-j")) true)))

(defn get-info [pid]
  {:name (str/trim (:out (sh "ps" "-p" (str pid) "-o" "comm=")))
   :children (let [out (:out (sh "pgrep" "-P" (str pid)))]
               (if (empty? out)
                 '()
                 (map #(Integer/parseInt %) (str/split-lines out))))})

; breath-first search for the last known process
(defn search [& pids]
  (when (seq pids)
    (let [info (map get-info pids)
          pids (zipmap pids info)]
      (or (apply search (mapcat :children info))
          (let [known (filter (fn [[_ {:keys [name]}]] (contains? known-procs name)) pids)]
            (when (= 1 (count known))
              (update (first known) 1 :name)))))))

(defn write-current-location [name pid location nvim_pipe]
  (let [path (str locations-path name "-" pid ".txt")
        data (json/generate-string {:location location :nvim_pipe nvim_pipe})]
    (spit path data)))

(defn read-data [name pid]
  (try
    (-> (str locations-path name "-" pid ".txt")
        slurp
        str/trim
        (json/parse-string true))
    (catch Exception _
      {:location (System/getenv "HOME") :nvim_pipe nil})))

(defn get-data []
  (let [pid (current-pid)
        [pid name] (search pid)]
    (read-data name pid)))

(defn delete-files-in-dir [dir-path]
  (let [dir (File. dir-path)
        files (.listFiles dir)]
    (doseq [file files]
      (when (.isFile file)
        (.delete file)))))

(defn get-cmd [_m]
  (println (json/generate-string (get-data))))
(defn write-cmd [{:keys [args]}]
  (let [[name pid location nvim_pipe] args]
    (write-current-location name pid location nvim_pipe)))
(defn clear-cmd [_m] (delete-files-in-dir locations-path))

(def table [{:cmds ["get"]            :fn get-cmd}
            {:cmds ["write"]          :fn write-cmd}
            {:cmds ["clear"]          :fn clear-cmd}])

; (cli/dispatch table *command-line-args*)
(defn -main [& args]
  (cli/dispatch table args))
