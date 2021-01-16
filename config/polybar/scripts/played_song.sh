#!/bin/bash

output=$(playerctl metadata --format "{{xesam:artist}}: {{title}}" 2>/dev/null)
disp=$(echo $output | colrm 60)
current_pc=$(cat ~/.config/ncmpcpp/scripts/current_pc)
echo "$current_pc − $disp"
