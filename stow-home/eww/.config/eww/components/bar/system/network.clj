#! /usr/bin/env bb

(require '[babashka.cli :as cli]
         '[clojure.java.shell :as shell :refer [sh]]
         '[cheshire.core :as json]
         '[clojure.string :as str])

(def interval-ms 2000) ; 2s

(defn wired-icon [state]
  (case state
    "none" "󰪎"
    "unknown" "󰲜"
    "portal" "󰲛"
    "limited" "󰪎"
    "full" "󰛳"))

(defn get-signal-strength []
  (->> (sh "nmcli" "-f" "in-use,signal" "dev" "wifi")
       :out
       str/split-lines
       (filter #(str/starts-with? % "*"))
       first
       (re-matches #"\*\s+(\S+)\s+")
       second
       Integer/parseInt))

(def gradient-icons ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"])
(defn format-icon [level]
  (get gradient-icons
       (int (Math/ceil (* (- (count gradient-icons) 1)
                          (/ level 100))))))

(defn wireless-icon [state]
  (case state
    "none" "󰪎"
    "unknown" "󰤭"
    "portal" "󰤪"
    "limited" "󰪎"
    "full" (format-icon (get-signal-strength))))

(defn parse-device [type devices]
  (some->> devices
           (filter #(str/starts-with? % type))
           first
           (re-matches #"\S+\s+connected\s+(.+)")
           second
           str/trim))

(defn get-info []
  (let [devices (->> (sh "nmcli" "-f" "type,state,connection" "device")
                     :out
                     str/split-lines
                     rest)
        state (-> (sh "nmcli" "networking" "connectivity")
                  :out
                  str/trim)
        wired-name (parse-device "ethernet" devices)
        wireless-name (parse-device "wifi" devices)]
    (json/generate-string (if wired-name
                            {:icon (wired-icon state) :name wired-name}
                            {:icon (wireless-icon state) :name (or wireless-name "none")}))))

(defn get-cmd [_m] (println (get-info)))
(defn listen-cmd [_m]
  (while true
    (println (get-info))
    (Thread/sleep interval-ms)))

(def table [{:cmds ["get"]    :fn get-cmd}
            {:cmds ["listen"] :fn listen-cmd}])

(cli/dispatch table *command-line-args*)
