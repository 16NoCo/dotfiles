#!/usr/bin/env bash
#             __ _       _     _            _              _   _
#  _ __ ___  / _(_)     | |__ | |_   _  ___| |_ ___   ___ | |_| |__
# | '__/ _ \| |_| |_____| '_ \| | | | |/ _ \ __/ _ \ / _ \| __| '_ \
# | | | (_) |  _| |_____| |_) | | |_| |  __/ || (_) | (_) | |_| | | |
# |_|  \___/|_| |_|     |_.__/|_|\__,_|\___|\__\___/ \___/ \__|_| |_|
#
# Original Author: Nick Clyde (clydedroid)
# Adapted for theming.
#
# A script that generates a rofi menu that uses bluetoothctl to
# connect to bluetooth devices and display status info.
#
# Inspired by networkmanager-dmenu (https://github.com/firecat53/networkmanager-dmenu)
# Thanks to x70b1 (https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/system-bluetooth-bluetoothctl)
#
# Depends on:
#   Arch repositories: rofi, bluez-utils (contains bluetoothctl)

# Checks if bluetooth controller is powered on
power_on() {
    #if bluetoothctl show | grep -q "Powered: yes"; then
    if echo show | bluetoothctl | grep -q "Powered: yes"; then
        return 0
    else
        return 1
    fi
}

# Toggles power state
toggle_power() {
    if power_on; then
        echo power off | bluetoothctl
    else
        echo power on | bluetoothctl
    fi
}

# Checks if controller is scanning for new devices
scan_on() {
    if echo show | bluetoothctl | grep -q "Discovering: yes"; then
        echo "Scan: on"
        return 0
    else
        echo "Scan: off"
        return 1
    fi
}

# Toggles scanning state
toggle_scan() {
    if scan_on; then
        kill $(pgrep -f "bluetoothctl scan on")
        echo scan off | bluetoothctl
    else
        echo scan on | bluetoothctl
    fi
}

# Checks if controller is able to pair to devices
pairable_on() {
    if echo show | bluetoothctl | grep -q "Pairable: yes"; then
        echo "Pairable: on"
        return 0
    else
        echo "Pairable: off"
        return 1
    fi
}

# Toggles pairable state
toggle_pairable() {
    if pairable_on; then
        echo pairable off | bluetoothctl
    else
        echo pairable on | bluetoothctl
    fi
}

# Checks if controller is discoverable by other devices
discoverable_on() {
    if echo show | bluetoothctl | grep -q "Discoverable: yes"; then
        echo "Discoverable: on"
        return 0
    else
        echo "Discoverable: off"
        return 1
    fi
}

# Toggles discoverable state
toggle_discoverable() {
    if discoverable_on; then
        echo discoverable off | bluetoothctl
    else
        echo discoverable on | bluetoothctl
    fi
}

# Checks if a device is connected
device_connected() {
    device_info=$(echo "info $1" | bluetoothctl)
    if echo "$device_info" | grep -q "Connected: yes"; then
        return 0
    else
        return 1
    fi
}

# Toggles device connection
toggle_connection() {
    if device_connected $1; then
        echo disconnect $1 | bluetoothctl
    else
        echo connect $1 | bluetoothctl
    fi
}

# Checks if a device is paired
device_paired() {
    device_info=$(echo "info $1" | bluetoothctl)
    if echo "$device_info" | grep -q "Paired: yes"; then
        echo "Paired: yes"
        return 0
    else
        echo "Paired: no"
        return 1
    fi
}

# Toggles device paired state
toggle_paired() {
    if device_paired $1; then
        echo remove $1 | bluetoothctl
    else
        echo pair $1 | bluetoothctl
    fi
}

# Checks if a device is trusted
device_trusted() {
    device_info=$(echo "info $1" | bluetoothctl)
    if echo "$device_info" | grep -q "Trusted: yes"; then
        echo "Trusted: yes"
        return 0
    else
        echo "Trusted: no"
        return 1
    fi
}

# Toggles device connection
toggle_trust() {
    if device_trusted $1; then
        echo untrust $1 | bluetoothctl
    else
        echo trust $1 | bluetoothctl
    fi
}

# Prints a short string with the current bluetooth status
# Useful for status bars like polybar, etc.
print_status() {
    if power_on; then
        printf ''

        mapfile -t paired_devices < <(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
        counter=0

        for device in "${paired_devices[@]}"; do
            if device_connected $device; then
                device_alias=$(bluetoothctl info $device | grep "Alias" | cut -d ' ' -f 2-)

                if [ $counter -gt 0 ]; then
                    printf ", %s" "$device_alias"
                else
                    printf " %s" "$device_alias"
                fi

                ((counter++))
            fi
        done

       if [ $counter -eq 0 ]; then
           printf " On"
       fi
    else
        echo " Off"
    fi
}

# A submenu for a specific device that allows connecting, pairing, and trusting
device_menu() {
    device=$1

    # Get device name and mac address
    device_name=$(echo $device | cut -d ' ' -f 3-)
    mac=$(echo $device | cut -d ' ' -f 2)
    echo "$mac ← $device_name"

    # Build options
    if device_connected $mac; then
        connected="Connected: yes"
    else
        connected="Connected: no"
    fi
    paired=$(device_paired $mac)
    trusted=$(device_trusted $mac)
    options="$connected\n$paired\n$trusted"

    # Open rofi menu, read chosen option
    prompt="$main_prompt$device_name "
    len=$(~/.bin/text_width.py "$prompt" 20 $font)
    max_len=$(~/.bin/text_width.py -max "$options" 20 ~/.local/share/fonts/MinecraftRegular-Bmg3.otf)
    rofi_options="-theme-str 'listview{margin:0 calc(100%- $((4*2+2*2+2+len+max_len))px) 0 $((len+2))px;}'"

    cmd="$rofi_command $rofi_options -p \"$prompt\""
    chosen="$(echo -e "$options" | eval $cmd)"

    # Match chosen option to command
    case $chosen in
        "")
            echo "No option chosen."
            ;;
        $connected)
            toggle_connection $mac
            ;;
        $paired)
            toggle_paired $mac
            ;;
        $trusted)
            toggle_trust $mac
            ;;
    esac
}

# Opens a rofi menu with current bluetooth status and options to connect
show_menu() {
    # Get menu options
    if power_on; then
        power="Power: on"

        # Human-readable names of devices, one per line
        # If scan is off, will only list paired devices
        devices=$(echo "devices" | bluetoothctl | grep ^Device | cut -d ' ' -f 3-)

        # Get controller flags
        scan=$(scan_on)
        pairable=$(pairable_on)
        discoverable=$(discoverable_on)
        divider="---------"

        # Options passed to rofi
        options="$devices\n$divider\n$power\n$scan\n$pairable\n$discoverable"
    else
        power="Power: off"
        options="$power"
    fi

    # Open rofi menu, read chosen option
    len=$(~/.bin/text_width.py "$main_prompt" 20 $font)
    max_len=$(~/.bin/text_width.py -max "$options" 20 ~/.local/share/fonts/MinecraftRegular-Bmg3.otf)
    rofi_options="-theme-str 'listview{margin:0 calc(100%- $((4*2+2*2+2+len+max_len))px) 0 $((len+2))px;}'"

    cmd="$rofi_command $rofi_options -p \"$main_prompt\""
    chosen="$(echo -e "$options" | eval $cmd)"

    # Match chosen option to command
    case $chosen in
        "" | $divider)
            echo "No option chosen."
            ;;
        $power)
            toggle_power
            ;;
        $scan)
            toggle_scan
            ;;
        $discoverable)
            toggle_discoverable
            ;;
        $pairable)
            toggle_pairable
            ;;
        *)
            #device=$(bluetoothctl devices | grep "$chosen")
            device=$(echo "devices" | bluetoothctl | grep ^Device | grep "$chosen")
            # Open a submenu if a device is selected
            if [[ $device ]]; then device_menu "$device"; fi
            ;;
    esac
}


# Rofi command to pipe into, can add any options here
rofi_command="rofi -dmenu -no-fixed-num-lines -i"

font=~/.local/share/fonts/MinecraftRegular-Bmg3.otf

case "$1" in
    --status)
        print_status
        ;;
    *)
        main_prompt="/bluetooth "
        show_menu
        ;;
esac
