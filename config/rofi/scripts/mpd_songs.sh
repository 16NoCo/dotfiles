#!/bin/bash

prev=0

defaultCover="$HOME/.config/rofi/scripts/mpd_songs/default.png"
coverLocation="/tmp/rofi-mpd_cover.png"
defaultMusicDir="$HOME/Music"
defaultExtRegex=".+\.png|.+\.jpg"
defaultCacheName="cover-rofi.png"

# Get current song relative path to defaultMusicDir
file="$(mpc current -f %file%)"
cover="$defaultCover"

# If MPC returned a path to a playing song file
if [[ "$file" ]]; then
    fileDir="$defaultMusicDir/${file%"$(basename "$file")"}"
    cover="$(find "$fileDir" -type f -regextype posix-extended -regex "$defaultExtRegex" -print -quit)"
    if ! [[ "$cover" ]]; then
        cover="$(find /tmp/ -iname 'cover-*' -printf "%T@ %p\n" 2> /dev/null | sort -n | tail -n 1 | cut -d " " -f 2-)"
    fi
    if [[ "$cover" ]]; then
        # Bordercolor green commented bellow for fine tunning
        #convert "$cover" -resize 221x220\! -bordercolor green -border 12x12 "$coverLocation"
        convert "$cover" -resize 221x220\! -bordercolor none -border 12x12 "$coverLocation"
        cover="$coverLocation"
    else
        cover="$defaultCover"
    fi
    #cover="$(find "$fileDir" -type f -name "defaultCacheName" -print -quit)"

    #if [[ ! "$cover" ]]; then
    #    cover="$(find "$fileDir" -type f -regextype posix-extended -regex "$defaultExtRegex" -print -quit)"
    #    echo "$cover"
    #    if [[ "$cover" ]]; then
    #        # Bordercolor green commented bellow for fine tunning
    #        convert "$cover" -resize 221x220\! -bordercolor none -border 12x12 "$fileDir$defaultCacheName"
    #        cover="$fileDir/$defaultCacheName"
    #    else
    #        cover="$defaultCover"
    #    fi
    #fi
fi

pos="$(mpc current -f %position%)"
if [[ $prev -lt 0 ]]; then
    list="$(mpc playlist)"
    prev=$((pos-1))
else
    list="$(mpc playlist | tail -n +$((pos-prev)))"
fi
if [[ $(mpc status | grep "playing") ]]; then
    status=""
else
    status=""
fi

list_num="$(echo "$list" | awk -v POS=$((prev+1)) -v STATUS=$status 'NR>POS {printf("%-4s%s\n", NR-POS, $0); next} NR==POS {print STATUS "   " $0; next} NR==POS-1 {print "<   " $0; next} {print "     " $0}')"

#feh --bg-fill Pictures/wallpapers/i3wm_nord_bar_highlight.png

sel=$(echo "$list_num" | rofi -dmenu -columns 1 -format i -fake-background "$cover" -fake-transparency -theme themes/music -p 'mpd:' -selected-row $prev -scroll-method 1 -i)

#feh --bg-fill Pictures/wallpapers/i3wm_nord.png

num=$((sel-prev))
if [[ $sel ]]; then
    if [[ $num == 0 ]]; then
        mpc toggle
    else
        mpc play $((pos+num))
    fi
fi
