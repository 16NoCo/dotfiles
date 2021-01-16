#!/bin/bash

track=$(mpc -f %file% current)
current_pc=$(mpc sticker "$track" get playcount 2>/dev/null)
if [[ $? == 1 ]]; then
    current_pc=0
    mpc sticker "$track" set playcount 0
else
    current_pc=$(echo $current_pc | cut -d= -f2)
fi

playing=true
file_var="$(dirname $0)/last_played"
last_played=$(cat $file_var 2>/dev/null)
if [[ $? == 1 ]]; then
    touch $file_var
    last_played=""
    # notify-send "creating file $file_var"
elif [[ $last_played == $track ]]; then
    advance=$(mpc | grep %\) | cut -d \( -f2 | cut -d% -f1)
    if [[ $advance -gt 25 ]]; then
        playing=false
        # notify-send "already played that"
    fi
fi

echo $current_pc > "$(dirname $0)/current_pc"

duration=$(mpc | grep %\) | sed "s/^.*\/\([0-9]*:[0-9]*\).*$/\1/" | awk -F: '{ if (NF == 1) {print $NF} else if (NF == 2) {print $1 * 60 + $2} else if (NF==3) {print $1 * 3600 + $2 * 60 + $3} }')
sleep_time=5
if [[ $duration -lt 25 ]]; then
    sleep_time=1
fi

while $playing; do
    current=$(mpc -f %file% current)
    if [[ "$current" == "$track" ]]; then
        advance=$(mpc | grep %\) | cut -d \( -f2 | cut -d% -f1)
        #notify-send "Progression: $advance"
        if [[ $advance -gt 75 ]]; then
            mpc sticker "$track" set playcount $(($current_pc+1))
            #notify-send "$(($current_pc+1)): $track"
            playing=false
            echo $track > $file_var
        fi
    else
        #notify-send "changed: $track"
        playing=false
    fi
    sleep $sleep_time
done
