#!/bin/bash

last=0
count=0
while ( true )
do
	lsOutput=$(lsusb | grep Chicony | cut -c 1-3)
	if [[ "$lsOutput" == "Bus" ]]; then
		if [[ "$last" != "modified" ]]; then
			gsettings set org.gnome.desktop.screensaver picture-uri ~/.config/weatherdesk_walls/WeatherDesk-master/modified.jpg
			last="modified"
		fi
	else
		if [[ "$last" != "original" ]]; then
			gsettings set org.gnome.desktop.screensaver picture-uri ~/.config/weatherdesk_walls/WeatherDesk-master/original.jpg
			last="original"
		fi
	fi
	count=$(($count+1))
	if [[ "$count" -gt $((120)) ]]; then
		count=0
		last=0
	fi
	sleep 1
done
