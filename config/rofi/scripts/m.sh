#!/bin/bash
 
echo -e "\0use-hot-keys\x1ftrue"
case $ROFI_RETV in
    1) echo -e "\0message\x1fMSG: execute '$ROFI_INFO'";;
    10) echo -e "\0message\x1fMSG: custom key 1 just pressed";;
esac
 
echo -e "execute\0info\x1fpath to some script"
