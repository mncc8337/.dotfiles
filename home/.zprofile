#!/bin/zsh

wayland_compositor=hyprland

function X_start {
    if [ -f ~/.xorg.log ]; then
        mv ~/.xorg.log ~/.xorg.old.log
    fi

    startx -- -keeptty > ~/.xorg.log 2>&1
}

function wayland_start {
    if [ -f ~/.$wayland_compositor.log ]; then
        mv ~/.$wayland_compositor.log ~/.$wayland_compositor.old.log
    fi

    $wayland_compositor
}

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    # X_start
    wayland_start
fi
