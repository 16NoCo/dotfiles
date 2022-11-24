#!/bin/bash

# COLORS (default: Nord color scheme)
fg_alt='#81A1C1'
urgent='#BF616A'


t=0

toggle() {
    t=$(((t + 1) % 2))
}


trap "toggle" USR1

while true; do
#    if [[ $(cat /sys/class/net/wlp58s0/carrier) -eq 1 ]]; then
    netstate=$(nmcli -m tabular d)
    netstatew=$(echo "$netstate" | grep wifi)
    if [[ $netstate == *" connected"* ]]; then
        disp=""
        airplane="%{F$fg_alt}"
        while read line; do
            if [[ $line == *"wifi"* ]]; then
                airplane=""
                strength=$(nmcli dev wifi | grep "*" | awk -F "bit/s" '{print $2}' |\
                    sed 's/^ *//g' | cut -d " " -f1)
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
                    disp="${disp:+$disp  }%{F$fg_alt}$label%{F-}"
                else
                    ip=$(ifconfig wlp58s0 | grep "inet " | cut -d "i" -f 2 | cut -d " " -f 2)
                    ssid=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d: -f2)
                    disp="${disp:+$disp  }%{F$fg_alt}$label%{F-} $ssid $ip"
                fi
            elif [[ $line == *"ethernet"* ]]; then
                label=""
                if [[ $line == *"enp0s20f0u1"* ]]; then
                    label=""
                fi
                if [[ $t -eq 0 ]]; then
                    disp="${disp:+$disp  }%{F$fg_alt}$label%{F-}"
                else
                    dev=$(echo $line | cut -d " " -f1)
                    ip=$(ifconfig $dev | grep "inet " | cut -d "i" -f 2 | cut -d " " -f 2)
                    disp="${disp:+$disp  }%{F$fg_alt}$label%{F-} $ip"
                fi
            fi
        done <<< $(echo "$netstate" | grep " connected")
        if [[ $t -eq 0 ]]; then
            echo $disp
        else
            if [[ $netstatew == *"disconnected"* ]]; then
                echo "%{F$fg_alt}  $disp"
            elif [[ $netstatew == *"unavailable"* || $netstatew == *"unmanaged"* ]]; then
                echo "%{F$fg_alt}  $disp"
            else
                echo $disp
            fi
        fi
    elif [[ $netstatew == *"disconnected"* ]]; then
        echo "%{F$fg_alt}"
    elif [[ $netstatew == *"unavailable"* || $netstatew == *"unmanaged"* ]]; then
        echo "%{F$fg_alt}"
    fi

    sleep 10 &
    wait
done
