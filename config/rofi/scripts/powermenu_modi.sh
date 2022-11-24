#!/bin/bash

case $@ in
    $power_off)
        ~/.config/rofi/scripts/promptmenu.sh --yes-command "systemctl poweroff" --query "Shutdown?"
        ;;
    $reboot)
        ~/.config/rofi/scripts/promptmenu.sh --yes-command "systemctl reboot" --query "Reboot?"
        ;;
    $lock)
        #i3lock-fancy
        ~/.config/rofi/scripts/promptmenu.sh --yes-command "i3lock-fancy" --query "Lock?"
        ;;
    $suspend)
        mpc -q pause
        systemctl suspend
        ;;
    $log_out)
        i3-msg exit
        ;;
esac

#rofi_command="rofi -dmenu -theme themes/nord_powermenu -selected-row 2"

### Options ###
power_off="\0meta\x1finfo,test\n"
reboot=""
lock=""
suspend="鈴"
log_out=""
# Variable passed to rofi
options="$power_off\n$reboot\n$lock\n$suspend\n$log_out"

#chosen="$(echo -e "$options" | $rofi_command)"
echo -en $power_off
echo $reboot
echo $lock
echo $suspend
echo $log_out
