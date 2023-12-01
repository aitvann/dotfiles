#! /usr/bin/env bb

(require '[babashka.cli :as cli]
         '[clojure.java.shell :as shell :refer [sh]]
         '[cheshire.core :as json]
         '[clojure.walk :as walk])

(defn shrink [val lower-bound upper-bound]
  (-> val (min upper-bound) (max lower-bound)))

(def interval-ms 1000) ; 1s
(def main-battery-name "BAT0")
(def critical-level 10)

(def charging-full "󰂄")
(def discharging-empty "󱃍")
(def icons {:charging    ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
            :discharging ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]})

(defn format-icon [{:keys [status capacity]}]
  (case [status capacity]
    [:charging    100]  charging-full
    [:discharging 100]  (last (:discharging icons))
    [:discharging 0]    discharging-empty
    (get (status icons) (quot capacity 10))))

(defn critical? [{:keys [status capacity]}]
  (and (<= capacity critical-level)
       (= status :discharging)))

(defn get-main-battery []
  (-> (sh "eww" "get" "EWW_BATTERY")
      :out
      json/parse-string
      (get main-battery-name)
      walk/keywordize-keys
      (update :capacity #(shrink % 0 100)) ; EWW_BATTERY can sometimes return value above 100
      (update :status #(case %
                         "Charging"     :charging
                         "Not charging" :discharging
                         "Discharging"  :discharging))))

(defn get-info []
  (let [{:keys [capacity] :as battery} (get-main-battery)]
    (json/generate-string {:capacity capacity
                           :icon (format-icon battery)
                           :is_critical (critical? battery)})))

(defn get-cmd [_m] (println (get-info)))
(defn listen-cmd [_m]
  (while true
    (println (get-info))
    (Thread/sleep interval-ms)))

(def table [{:cmds ["get"]    :fn get-cmd}
            {:cmds ["listen"] :fn listen-cmd}])

(cli/dispatch table *command-line-args*)
