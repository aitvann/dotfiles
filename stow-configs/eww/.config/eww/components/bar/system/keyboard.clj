#! /usr/bin/env bb

(require '[babashka.cli :as cli]
         '[clojure.java.shell :as shell :refer [sh]]
         '[clojure.string :as str]
         '[cheshire.core :as json])

(def interval-ms 1000) ; 1s
(def keyboards ["dao-keyboard" "dao-keyboard-2" "at-translated-set-2-keyboard"])

(defn start-process [command & args]
  (let [pb (ProcessBuilder. (into [command] args))]
    (.start pb)))

(defn show-osd [keymap] (start-process "sh" "-c" (str  "~/.config/eww/components/osd/osd.clj " keymap)))

(defn format-keymap [keymap]
  (cond
    (str/starts-with? keymap "English") "en"
    (= keymap "Russian") "ru"
    :else keymap))

(defn get-keyboards []
  (let [devices
        (->> (sh "hyprctl" "devices" "-j")
             :out
             (#(json/parse-string % keyword))
             :keyboards)]
    (->> keyboards
         (map (fn [kb] (first (filter #(= (:name %) kb) devices))))
         (filter identity))))

(defn get-info []
  (some->> (get-keyboards)
           first
           :active_keymap
           format-keymap))

(defn switch-keymap []
  #_{:clj-kondo/ignore [:unused-value]}
  (last (for [{:keys [name]} (get-keyboards)]
          (sh "hyprctl" "switchxkblayout" name "next")))
  (let [keymap (get-info)]
    (sh "eww" "update" (str "keyboard=" keymap))
    (show-osd keymap)))

(defn get-cmd [_m] (println (get-info)))
(defn listen-cmd [_m]
  (while true
    (println (get-info))
    (Thread/sleep interval-ms)))
(defn switch-keymap-cmd [_m] (switch-keymap))

(def table [{:cmds ["get"]                   :fn get-cmd}
            {:cmds ["listen"]                :fn listen-cmd}
            {:cmds ["switch"]                :fn switch-keymap-cmd}])

(cli/dispatch table *command-line-args*)
