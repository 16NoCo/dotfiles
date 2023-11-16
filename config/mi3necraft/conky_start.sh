#!/bin/bash

## Inspired from terdon's https://unix.stackexchange.com/a/139153

## SETTINGS VALUES
main_monitor="eDP1"
def_x_bot=0
def_y_bot=46
def_x_left=4
def_y_left=4
def_x_right=4
def_y_right=4
bot=~/.config/conky/mineconkyrc_bottom
left=~/.config/conky/mineconkyrc_left
right=~/.config/conky/mineconkyrc_right

## Get the number of monitors
#n_mon=$(xrandr | grep -cw connected);      # Connected monitors
n_mon=$(xrandr | grep -cw +);               # "Active" monitors

## If only 1 monitor
if [ "$n_mon" -eq 1 ]
then
    ## Set the gap_x to default value
    sed -i.bak "s/gap_x = .*/gap_x = $def_x_bot,/" $bot
    sed -i.bak "s/gap_x = .*/gap_x = $def_x_left,/" $left
    sed -i.bak "s/gap_x = .*/gap_x = $def_x_right,/" $right
else
    ## Get the offset of main monitor
    x_pos=$(xrandr | grep $main_monitor | cut -d ' ' -f 4 | cut -d+ -f 2)
    y_pos=$(xrandr | grep $main_monitor | cut -d ' ' -f 4 | cut -d+ -f 3)

    x_bot_offset=$((x_pos/2+def_x_bot))
    x_left_offset=$((def_x_left))
    x_right_offset=$((x_pos+def_x_right))
    sed -i.bak "s/gap_x = .*/gap_x = $x_bot_offset,/" $bot
    sed -i.bak "s/gap_x = .*/gap_x = $x_left_offset,/" $left
    sed -i.bak "s/gap_x = .*/gap_x = $x_right_offset,/" $right

    y_bot_offset=$((y_pos+def_y_bot))
    y_left_offset=$((def_y_left))
    y_right_offset=$((def_y_right))
    sed -i.bak "s/gap_y = .*/gap_y = $y_bot_offset,/" $bot
    sed -i.bak "s/gap_y = .*/gap_y = $y_left_offset,/" $left
    sed -i.bak "s/gap_y = .*/gap_y = $y_right_offset,/" $right
fi

#killall -9 conky
#conky -c $bot &
#conky -c $left &
#conky -c $right &
#touch $bot

feh --bg-fill ~/.config/mi3necraft/resources/wallpaper.png
