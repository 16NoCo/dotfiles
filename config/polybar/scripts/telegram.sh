#!/bin/bash

# COLORS (default: Nord color scheme)
fg_alt='#81A1C1'
urgent='#BF616A'


t=0
blink=0

toggle() {
    i3-msg '[class="TelegramDesktop"] focus'
    t=$(((t + 1) % 2))
}


trap "toggle" USR1

while true; do
    wins=$(xdotool search --class 'TelegramDesktop')
    active="false"
    for win in $wins; do
        name=$(xdotool getwindowname $win)
        if [[ $name == "Telegram"* ]] && ! [[ $name == "TelegramDesktop" ]]; then
            num=$(echo $name | sed 's/Telegram\( (\(.*\))\)\?/\2/')
            echo "%{F$fg_alt}%{F-}${num:+ $num}"
            active="true"
        fi
    done
    if [[ $active == "false" ]]; then
        echo ""
    fi
    sleep 5 &
    wait
done
