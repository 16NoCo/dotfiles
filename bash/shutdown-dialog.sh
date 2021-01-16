#!/bin/bash

# Aimed for non-tiling WM
# Reproduce behaiviour of Windows' alt+F4:
#    - display a 'shutdown menu' when desktop is focused
#    - close application (trigger alt+F4) when desktop is not focused

desktopid=$(xdotool search --classname "desktop_window")

focused=$(xdotool getactivewindow)

if [ "$focused" = "$desktopid" ]
	then
		action=$(zenity --entry --title="Shut down" --text="What do you want the computer to do?" --entry-text="Shut down" Restart Suspend --timeout=60 --window-icon=coffee.png 2> /dev/null)

		if [ "$action" = "Shut down" ]
			then
				echo "Shutting down"
				systemctl poweroff
		elif [ "$action" = "Restart" ]
			then
				echo "Restarting"
				systemctl reboot
		elif [ "$action" = "Suspend" ]
			then
				echo "Suspending"
				systemctl suspend
		else
			echo "Canceling"
		fi
else
	sleep 0.1
	xdotool key --clearmodifiers alt+F4
fi
