#! /usr/bin/env bb

(require '[babashka.cli :as cli]
         '[clojure.java.shell :as shell :refer [sh]]
         '[cheshire.core :as json])

(def step 10) ; 10%
(def interval-ms 1000) ; 1s

(defn show-osd [level icon] (sh "xargs" "sh" "-c" "~/.config/eww/components/osd/osd.clj $0 $1" :in (str icon " " level)))

(defn gen-info [icon type]
  (json/generate-string {:icon icon
                         :type_icon type}))
(def icons
  {:source {:muted "󰍭"
            :gradient ["󰍮" "󰢳" "󰍬" "󰢴"]}
   :sink {:muted ""
          :gradient ["󰝟" "󰕿" "󰖀" "󰕾"]}})
(defn format-icon [kind {:keys [level muted]}]
  (let [{icon-muted :muted icons :gradient} (kind icons)]
    (if muted
      icon-muted
      (get icons
           (int (Math/ceil (* (- (count icons) 1)
                              (/ level 100))))))))

(def wpctl-aliases {:sink "@DEFAULT_SINK@"
                    :source "@DEFAULT_SOURCE@"})
(defn get-type-icon [kind]
  (let [{:keys [out]} (sh "wpctl" "inspect" (kind wpctl-aliases))
        bluez_output (last (re-matches #"(?is).*node\.name = \"(bluez).*" out))]
    (if bluez_output
      "󰂰"
      (case kind :sink "󰓃" :source "󰍰"))))
(defn update-eww [kind {:keys [level] :as level-info}]
  (let [icon (format-icon kind level-info)
        type-icon (get-type-icon kind)
        eww-var (case kind :sink "audio_sink" :source "audio_source")]
    (sh "xargs" "-d" " " "eww" :in (str "update " eww-var "=" (gen-info icon type-icon)))
    (show-osd level icon)))
(defn get-value [kind]
  (let [{:keys [out exit]} (sh "wpctl" "get-volume" (kind wpctl-aliases))
        [_ level muted] (re-matches #"(?s)Volume: ([0-9\.]+)( \[MUTED\])?.*" out)]
    (if (not= exit 0)
      {:level 0 :muted false}
      {:level (int (* 100 (Float/parseFloat level)))
       :muted (not (nil? muted))})))
(defn get-info [kind] (gen-info (format-icon kind (get-value kind)) (get-type-icon kind)))
(defn raise [kind]
  (sh "wpctl" "set-volume" "-l" "1.0" (kind wpctl-aliases) (str step "%+"))
  (update-eww kind (get-value kind)))
(defn lower [kind]
  (sh "wpctl" "set-volume" "-l" "1.0" (kind wpctl-aliases) (str step "%-"))
  (update-eww kind (get-value kind)))
(defn mute [kind]
  (sh "wpctl" "set-mute" (kind wpctl-aliases) "toggle")
  (update-eww kind (get-value kind)))

(defn start-process [command & args]
  (let [pb (ProcessBuilder. (into [command] args))]
    (.start pb)))

(defn args-to-kind [{:keys [args]}]
  (case (first args)
    "sink" :sink
    "source" :source
    (throw (Exception. "No such kind"))))

(defn raise-cmd [m] (raise (args-to-kind m)))
(defn lower-cmd [m] (lower (args-to-kind m)))
(defn mute-cmd [m] (mute (args-to-kind m)))
(defn get-cmd [m] (println (get-info (args-to-kind m))))
(defn listen-cmd [m]
  (while true
    (println (get-info (args-to-kind m)))
    (Thread/sleep interval-ms)))
(defn select-sink-cmd [_m] (start-process "pw-util" "select-sink"))
(defn select-source-cmd [_m] (start-process "pw-util" "select-source"))
(defn select-sink-profile-cmd [_m] (start-process "pw-util" "select-sink-profile"))
(defn select-source-profile-cmd [_m] (start-process "pw-util" "select-source-profile"))

(def table [{:cmds ["get"]                   :fn get-cmd}
            {:cmds ["listen"]                :fn listen-cmd}
            {:cmds ["up"]                    :fn raise-cmd}
            {:cmds ["down"]                  :fn lower-cmd}
            {:cmds ["mute"]                  :fn mute-cmd}
            {:cmds ["select-sink"]           :fn select-sink-cmd}
            {:cmds ["select-source"]         :fn select-source-cmd}
            {:cmds ["select-sink-profile"]   :fn select-sink-profile-cmd}
            {:cmds ["select-source-profile"] :fn select-source-profile-cmd}])

(cli/dispatch table *command-line-args*)
