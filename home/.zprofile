#!/bin/zsh

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    if [ -f ~/.xorg.log ]; then
        mv ~/.xorg.log ~/.xorg.old.log
    fi

    startx -- -keeptty > ~/.xorg.log 2>&1
fi
