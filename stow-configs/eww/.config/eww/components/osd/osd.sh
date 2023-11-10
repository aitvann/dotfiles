#! /bin/sh

eww update osd="{ \"icon\": \"$1\", \"value\": \"$2\" }"
NOW=$(date +%s)
eww update osd_time=$NOW

# Open window if it isn't open yet
if ! [[ $(eww windows | grep '^\*osd$') ]]; then
    eww open osd

    # Wait until enough time has passed from last OSD activation
    # and close the window
    while [ 1 ]
    do
        sleep 1
        TIME=$(eww get osd_time)
        NOW=$(date +%s)
        # Then close the window
        if [[ $NOW > $(($TIME + 1)) ]]; then
            eww close osd
            break
        fi
    done
fi
