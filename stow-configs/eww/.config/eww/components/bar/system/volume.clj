#! /usr/bin/env bb

(require '[babashka.cli :as cli]
         '[clojure.java.shell :as shell :refer [sh]]
         '[cheshire.core :as json])

(def step 10) ; 10%
(def interval-ms 1000) ; 1s

(defn show-osd [level icon] (sh "xargs" "sh" "-c" "~/.config/eww/components/osd/osd.sh $0 $1" :in (str icon " " level)))

(defn gen-info [icon type]
  (json/generate-string {:icon icon
                         :type_icon type}))
(def icon-muted "")
(def icons ["󰝟" "󰕿" "󰖀" "󰕾"])
(defn format-icon [{:keys [level muted]}]
  (if muted
    icon-muted
    (get icons
         (int (Math/ceil (* (- (count icons) 1)
                            (/ level 100)))))))
(defn get-type-icon []
  (let [{:keys [out]} (sh "wpctl" "inspect" "@DEFAULT_SINK@")
        bluez_output (last (re-matches #"(?is).*node\.name = \"(bluez_output)\..*" out))]
    (if bluez_output "󰋋" "󰓃")))
(defn update-eww [{:keys [level] :as level-info}]
  (let [icon (format-icon level-info)
        type-icon (get-type-icon)]
    (sh "xargs" "-d" " " "eww" :in (str "update " "volume=" (gen-info icon type-icon)))
    (show-osd level icon)))
(defn get-value []
  (let [{:keys [out]} (sh "wpctl" "get-volume" "@DEFAULT_SINK@")
        [_ level muted] (re-matches #"(?s)Volume: ([0-9\.]+)( \[MUTED\])?.*" out)]
    {:level (int (* 100 (Float/parseFloat level)))
     :muted (not (nil? muted))}))
(defn get-info [] (gen-info (format-icon (get-value)) (get-type-icon)))
(defn raise []
  (sh "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_SINK@" (str step "%+"))
  (update-eww (get-value)))
(defn lower []
  (sh "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_SINK@" (str step "%-"))
  (update-eww (get-value)))
(defn mute []
  (sh "wpctl" "set-mute" "@DEFAULT_SINK@" "toggle")
  (update-eww (get-value)))

(defn raise-cmd [_m] (raise))
(defn lower-cmd [_m] (lower))
(defn mute-cmd [_m] (mute))
(defn get-cmd [_m] (println (get-info)))
(defn listen-cmd [_m]
  (while true
    (println (get-info))
    (Thread/sleep interval-ms)))

(def table [{:cmds ["get"]    :fn get-cmd}
            {:cmds ["listen"] :fn listen-cmd}
            {:cmds ["up"]     :fn raise-cmd}
            {:cmds ["down"]   :fn lower-cmd}
            {:cmds ["mute"]   :fn mute-cmd}])

(cli/dispatch table *command-line-args*)
