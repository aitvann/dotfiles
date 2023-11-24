#! /usr/bin/env bb

(require
 '[clojure.java.shell :as shell :refer [sh]]
 '[cheshire.core :as json]
 '[clojure.walk :as walk])

(def interval-ms 1000) ; 1s
(def main-battery-name "BAT0")
(def critical-level 10)

(def charging-full "󰂄")
(def discharging-empty "󱃍")
(def icons {:charging    ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
            :discharging ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]})

(defn format-icon [{:keys [status capacity]}]
  (case [status capacity]
    [:charging  100] charging-full
    [:discharging 0] discharging-empty
    (get (status icons) (quot capacity 10))))

(defn critical? [capacity]
  (<= capacity critical-level))

(defn get-main-battery []
  (-> (sh "eww" "get" "EWW_BATTERY")
      :out
      json/parse-string
      (get main-battery-name)
      walk/keywordize-keys
      (update :status #(case %
                         "Charging" :charging
                         "Discharging" :discharging))))

(defn get-info []
  (let [{:keys [capacity] :as battery} (get-main-battery)]
    (json/generate-string {:capacity capacity
                           :icon (format-icon battery)
                           :is-critical (critical? capacity)})))

(while true
  (println (get-info))
  (Thread/sleep interval-ms))
