#!/bin/bash

collapsed="memory-fold temperature-fold"
expanded="memory cpu temperature xkeyboard"

state_file="/tmp/fold_sys_polybar_state"

function collapse() {
    for m in $collapsed; do
        polybar-msg action "#$m.module_show"
    done
    for m in $expanded; do
        polybar-msg action "#$m.module_hide"
    done
    echo "collapsed" > $state_file
}

function show() {
    for m in $collapsed; do
        polybar-msg action "#$m.module_hide"
    done
    for m in $expanded; do
        polybar-msg action "#$m.module_show"
    done
    export FOLD_SYS=no
    echo "expanded" > $state_file
}

function toggle() {
    for m in "$collapsed $expanded"; do
        polybar-msg action "#$m.module_toggle"
    done
    #for e in $expanded; do
    #    polybar-msg action "#$e.module_show"
    #done
}

while getopts ":ce" opt
do
  case $opt in

    c|collapse )  collapse   ;;

    e|expand   )  show   ;;

    * )
        if [[ $(cat $state_file 2> /dev/null) == "collapsed" ]]; then
            show
            echo "true"
        else
            collapse
            echo "false"
        fi;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))
