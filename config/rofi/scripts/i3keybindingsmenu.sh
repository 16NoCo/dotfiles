#!/bin/bash

XDG_CONFIG_HOME="$HOME/.config"

theme_file=$(awk '
/^@import "colorschemes/ {
    split($2, arr, "/");
    print substr(arr[2], 0, length(arr[2])-1);
}' $XDG_CONFIG_HOME/rofi/themes/shared/settings.rasi)

# 0 - accent
# 1 - background-focus
# 2 - foreground
colors=$(awk '
function print_hex_color(text) {
    print substr(text, 1, length(text)-1);
}
/^\s+accent:/ {
    print_hex_color($2);
}
/^\s+background-focus:/ {
    print_hex_color($2);
}
/^\s+foreground:/ {
    print_hex_color($2);
}' $XDG_CONFIG_HOME/rofi/themes/shared/colorschemes/$theme_file)

col0=`echo $colors | cut -d ' ' -f 1`
col1=`echo $colors | cut -d ' ' -f 2`
col2=`echo $colors | cut -d ' ' -f 3`

list=$(i3-msg -t get_config \
    | awk -v pre_mode="<span bgcolor='$col1}' fgcolor='$col2' weight='heavy'> " \
          -v post_mode=" </span> " \
          -v pre_keybinding="<span fgcolor='$col0' weight='heavy'>" \
          -v post_keybinding="</span>" \
          -v separator=" " '
$1 == "#" {
    # Strip down the indent characters
    gsub(/^\s+/, "", $0);
    comment = substr($0, 3);
}
match($0, /^[^\s]+mode ".+"/) != 0 {
    mode = pre_mode toupper(substr($2, 2, length($2)-2)) post_mode;
}
match($0, /^}/) != 0 {
    mode = "";
}
$1 == "bindsym" {
    # Strip down the $ character from variables such as $Mod
    gsub(/\$/, "", $2)
    line = pre_keybinding $2 post_keybinding separator comment;
    # Replace $num in the comment by the number found in the keybinding
    if (index(comment, "$num")) {
        gsub(/\$num/, substr($2, match($2, /([[:digit:]]+)$/), length($2)), line);
    }
    print mode line;
}')

echo "$list" \
    | rofi -dmenu \
           -markup-rows \
           -i \
           -p "i3 Keybindings" \
           -theme themes/onedark &> /dev/null
           #-theme themes/i3keybindingsmenu.rasi &> /dev/null
