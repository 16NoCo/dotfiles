#!/bin/bash

rofi_command="rofi -dmenu -theme mods/powermenu -selected-row 2"

### Options ###
s_pow=""
s_reb=""
s_lock=""
s_susp="鈴"
s_logout=""

power_off="$s_pow\0meta\x1fpoweroff shutdown"
reboot="$s_reb\0meta\x1freboot restart"
lock="$s_lock\0meta\x1flock screen"
suspend="$s_susp\0meta\x1fsuspend"
log_out="$s_logout\0meta\x1flogout exit"
# Variable passed to rofi
options="$power_off\n$reboot\n$lock\n$suspend\n$log_out"

chosen="$(echo -e "$options" | $rofi_command)"
echo $chosen
case $chosen in
    $s_pow)
        ~/.config/rofi/scripts/promptmenu.sh --yes-command "systemctl poweroff" --query "Shutdown?" &
        ;;
    $s_reb)
        ~/.config/rofi/scripts/promptmenu.sh --yes-command "systemctl reboot" --query "Reboot?" &
        ;;
    $s_lock)
        #i3lock-fancy
        ~/.config/rofi/scripts/promptmenu.sh --yes-command "i3lock-fancy" --query "Lock?" &
        ;;
    $s_susp)
        mpc -q pause
        systemctl suspend
        ;;
    $s_logout)
        i3-msg exit
        ;;
esac

