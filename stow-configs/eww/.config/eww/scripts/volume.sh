#! /bin/sh

VOLUME_RAW=$(wpctl get-volume @DEFAULT_SINK@ | cut -c 9-)
VOLUME=$(bc <<< "$VOLUME_RAW*100/1")
STEP=5

function icon {
    if [[   $VOLUME -ge 66 ]]; then echo '󰕾'
    elif [[ $VOLUME -ge 33 ]]; then echo '󰖀'
    elif [[ $VOLUME -ge 1  ]]; then echo '󰕿'
    else echo '󰝟'
    fi
}

function level {
    echo $VOLUME
}

function lower {
    wpctl set-volume -l 1.0 @DEFAULT_SINK@ $STEP%-
    update
}

function raise {
    wpctl set-volume -l 1.0 @DEFAULT_SINK@ $STEP%+
    update
}

function update {
    STATE=$(get)
    eww update volume="$STATE"
    ~/.config/eww/components/osd/osd.sh $(echo $STATE | jq --raw-output .icon) $(echo $STATE | jq --raw-output .level)
}

function type_icon {
    SINK=$(wpctl inspect @DEFAULT_SINK@ | awk -F '[".]' '/node.name/ {print $3}')
    if [[ $SINK == *'bluez_output'* ]]; then echo "󰋋"
    else echo "󰓃"
    fi
}

function set_volume {
     wpctl set-volume @DEFAULT_SINK@ $1"%"
     eww update volume="$(get)"
}

function mic_mute_state {
    STATE=$(wpctl get-volume @DEFAULT_SOURCE@)
    if [[ $STATE != *"Muted"* ]]; then echo 'off'
    else echo 'on'; fi
}

function mic_icon {
    STATE=$(mic_mute_state)
    if [[ $STATE == 'off' ]]; then echo '󰍬'
    else echo '󰍭'; fi
}

function mute_mic_toggle {
    wpctl set-mute @DEFAULT_SOURCE@ toggle
    eww update volume="$(get)"
}

function get {
    echo "{
        \"level\": \"$(level)\",
        \"icon\": \"$(icon)\",
        \"type_icon\": \"$(type_icon)\",
        \"mic\": {
            \"mute_state\": \"$(mic_mute_state)\",
            \"icon\": \"$(mic_icon)\"
        }
    }"
}

if [[ $1 == 'mute_mic_toggle' ]]; then mute_mic_toggle; fi
if [[ $1 == 'down' ]]; then lower; fi
if [[ $1 == 'up' ]]; then raise; fi
if [[ $1 == 'set' ]]; then set_volue $2; fi
if [[ $1 == 'get' ]]; then get; fi
