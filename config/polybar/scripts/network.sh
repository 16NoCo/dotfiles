#!/bin/bash

t=0

toggle() {
    t=$(((t + 1) % 2))
}


trap "toggle" USR1

while true; do
#    if [[ $(cat /sys/class/net/wlp58s0/carrier) -eq 1 ]]; then
    netstate=$(nmcli | grep wlp58s0)
    if [[ $netstate == *"unavailable"* || $netstate == *"unmanaged"* ]]; then
        echo ""
    elif [[ $netstate == *"disconnected"* ]]; then
        echo ""
    else
        strength=$(nmcli dev wifi | grep "*" | awk -F "bit/s" '{print $2}' | sed 's/^ *//g' | cut -d " " -f1)
        printf -v strength "%03d" $strength
        case $strength in
            0[0-2][0-9]|03[0-5])
                label=".";;
            0[3-4][0-9]|05[0-5])
                label="";;
            0[5-6][0-9]|07[0-5])
                label="";;
            *)
                label="";;
        esac
        if [[ $t -eq 0 ]]; then
            echo "$label"
        else
            ip=$(ifconfig wlp58s0 | grep "inet " | cut -d "i" -f 2 | cut -d " " -f 2)
            ssid=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d: -f2)
            echo "$label $ssid $ip"
        fi
    fi
    sleep 10 &
    wait
done
