# Define layouts
setxkbmap -layout "fr,be" -variant "bepo,basic"

# Both Shift's as CapsLock
setxkbmap -option "shift:both_capslock"

# CapsLock as Escape
xmodmap -e "clear Lock"
xmodmap -e "keycode 66 = Escape"

# Menu as $mod when pressed along with other key
xmodmap -e "clear mod4"
xmodmap -e "add mod4 = Super_L Super_R"
spare_modifier="Super_R" 
xmodmap -e "keycode 135 = $spare_modifier"
xmodmap -e "add Super_R = $spare_modifier"
xmodmap -e "keycode any = Menu"
xcape -e "$spare_modifier=Menu"
