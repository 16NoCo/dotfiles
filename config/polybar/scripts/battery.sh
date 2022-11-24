#!/bin/bash

# COLORS (default: Nord color scheme)
fg_alt='#81A1C1'
urgent='#BF616A'


t=0
blink=0
prev_level=50

toggle() {
    t=$(((t + 1) % 2))
}


trap "toggle" USR1

while true; do
    batt=$(acpi | grep "Battery 0:" | cut -d: -f2-)
    plug=$(echo $batt | cut -d, -f1)
    fullstate=$(echo $batt | cut -d, -f2-)
    charge=$(echo $batt | cut -d, -f2 | cut -d% -f1)
    printf -v chargep "%03d" $charge
    if [[ $plug == "Discharging" ]]; then
        case $chargep in
            00[0-9]|010)
                if [[ $prev_level -ge 10 ]]; then
                    notify-send "Battery below 10%" -u critical -i battery-010 -h string:x-canonical-private-synchronous:battery -t 0
                fi
                label="%{B$urgent}%{F-}"
                if [[ $blink == 1 ]]; then
                    label="   ";
                fi
                blink=$(((blink + 1) % 2));;
            01[1-5])
                if [[ $prev_level -ge 16 ]]; then
                    notify-send "Battery below 15%" -u normal -i battery-020 -h string:x-canonical-private-synchronous:battery -t 20000
                fi
                label="%{F$urgent}";;
            01[6-9]|020)
                if [[ $prev_level -ge 21 ]]; then
                    notify-send "Battery below 20%" -u normal -i battery-020 -h string:x-canonical-private-synchronous:battery -t 20000
                fi
                label="%{F$urgent}";;
            02[1-9])
                label="";;
            03[0-9])
                label="";;
            04[0-9])
                label="";;
            05[0-9])
                label="";;
            06[0-9])
                label="";;
            07[0-9])
                label="";;
            08[0-9])
                label="";;
            09[0-9]|100)
                label="";;
            *)
                label="?";;
        esac
        prev_level=$charge
    elif [[ $plug == "Charging" ]]; then
        if [[ $prev_level -lt 20 ]]; then
            notify-send "Charging" -u low -i battery-100-charging -h string:x-canonical-private-synchronous:battery -t 1
        fi
        label=""
        prev_level=50
    elif [[ $plug == "Full" ]]; then
        label=""
        if [[ $blink == 1 ]]; then
            label="   ";
        fi
        blink=$(((blink + 1) % 2))
        prev_level=$charge
    else
        label=?
    fi
    if [[ $t -eq 0 ]]; then
        #echo `acpi | grep "Battery 0:" | cut -d, -f 2 | cut -d " " -f 2-`
        echo "%{F$fg_alt}$label%{F-} $charge%"
    else
        #echo `acpi | grep "Battery 0:" | cut -d, -f 2-3 | cut -d " " -f 2-`
        echo "%{F$fg_alt}$label%{F-} $fullstate"
    fi
    sleep 1 &
    wait
done
