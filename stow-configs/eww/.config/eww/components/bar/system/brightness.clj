#! /usr/bin/env bb

(require '[babashka.cli :as cli]
         '[clojure.java.shell :as shell :refer [sh]]
         '[cheshire.core :as json])

(def step 10) ; 10%
(def interval-ms 1000) ; 1s

(defn parse-output [{:keys [out]}]
  (Integer/parseInt (last (re-matches #"(?is).*Current brightness: \d+ \((\d+)%\).*" out))))
(defn show-osd [level icon] (sh "xargs" "sh" "-c" "~/.config/eww/components/osd/osd.sh $0 $1" :in (str icon " " level)))

(def icons ["󰛩" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨"])
(defn format-icon [level]
  (get icons (int (Math/ceil (/ level 11)))))

(defn gen-info [icon]
  (json/generate-string {:icon icon}))
(defn update-eww [level]
  (let [icon (format-icon level)]
    (sh "xargs" "-d" " " "eww" :in (str "update " "brightness=" (gen-info icon)))
    (show-osd level icon)))
(defn get-value [] (parse-output (sh "brightnessctl" "info")))
(defn get-info [] (gen-info (format-icon (get-value))))
(defn raise []
  (update-eww (parse-output (sh "brightnessctl" "set" (str step "%+")))))
(defn lower []
  (update-eww (parse-output (sh "brightnessctl" "set" (str step "%-")))))

(defn raise-cmd [_m] (raise))
(defn lower-cmd [_m] (lower))
(defn get-cmd [_m] (println (get-info)))
(defn listen-cmd [_m]
  (while true
    (println (get-info))
    (Thread/sleep interval-ms)))

(def table [{:cmds ["get"]    :fn get-cmd}
            {:cmds ["listen"] :fn listen-cmd}
            {:cmds ["up"]     :fn raise-cmd}
            {:cmds ["down"]   :fn lower-cmd}])

(cli/dispatch table *command-line-args*)
