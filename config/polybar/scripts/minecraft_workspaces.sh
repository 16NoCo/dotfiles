#!/bin/bash

c_foc='#fcfefc'
c_foc2='#caddc5'

used_ws=`i3-msg -t get_workspaces`
focused=`echo $used_ws | jq '.[] | select(.focused==true).num'`
unfocused=`echo $used_ws | jq '.[] | select(.focused==false).num'`

text=""

for (( i = 1; i < 10; i++ )); do
    if [[ " ${unfocused[*]} " =~ ${i} ]]; then
        name=`echo $used_ws | jq ".[] | select(.num==$i).name"`
        text+="%{A1:i3-msg workspace $name:}          %{A}"
    elif [[ " ${focused[*]} " =~ ${i} ]]; then
        name=`echo $used_ws | jq ".[] | select(.num==$i).name"`
        text+="%{A1:i3-msg workspace $name:}%{B$c_foc} %{B-}%{o$c_foc}%{+o}%{u$c_foc}%{+u}        %{-u}%{-o}%{B$c_foc} %{B-}%{A}"
    else
        text+=" %{u#626262}%{+u}%{o#939393}%{+o}%{B#191904}        %{B-}%{-o}%{-u} "
    fi
done

echo "$text"
