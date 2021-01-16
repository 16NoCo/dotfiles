#!/bin/bash

t=0
blink=0

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
            00[0-9])
                label='%{B#aa0000}'
                if [[ $blink == 1 ]]; then
                    label="   ";
                fi
                blink=$(((blink + 1) % 2));;
            01[0-9])
                label='%{B#aa0000}';;
            02[0-9])
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
    elif [[ $plug == "Charging" ]]; then
        label=""
    elif [[ $plug == "Full" ]]; then
        label=""
        if [[ $blink == 1 ]]; then
            label="   ";
        fi
        blink=$(((blink + 1) % 2))
    else
        label=?
    fi
    if [[ $t -eq 0 ]]; then
        #echo `acpi | grep "Battery 0:" | cut -d, -f 2 | cut -d " " -f 2-`
        echo "$label $charge%"
    else
        #echo `acpi | grep "Battery 0:" | cut -d, -f 2-3 | cut -d " " -f 2-`
        echo "$label $fullstate"
    fi
    sleep 1 &
    wait
done
