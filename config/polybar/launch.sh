#!/bin/bash

# Terminate already running bar instances
killall -q polybar
rm /tmp/ipc-example /tmp/ipc-tray

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar on multiple screens
if type "xrandr"; then
  #for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    #MONITOR=$m polybar --reload example &
    polybar --reload example &
    ln -s /tmp/polybar_mqueue.$! /tmp/ipc-example
    #MONITOR=$m polybar tray &
    polybar tray &
    ln -s /tmp/polybar_mqueue.$! /tmp/ipc-tray
    sleep 2 && echo "cmd:hide" >/tmp/ipc-tray
  #done
else
  polybar --reload example &
fi

echo "Bars launched..."
