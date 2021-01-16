#!/bin/bash

if [[ $(playerctl -l) ]];  then echo "true"; else echo "false"; return 1; fi
