# dotfiles
my .files for arch (btw)
### awm
![ps](access/2024-12-27_00-44-47.png)
### hyprland
img not provided bc im lazy
## included config
- nvim
- awesome
- hyprland
- rofi (copied somewhere else and i don't remember the source)
- ncmpcpp
- alacritty
- picom
- some shell scripts collected from internet
## before installing
> [!CAUTION]
> the config was made only for my use, thus it is not stable and will be changed constantly. you should only use this config as a reference.
- install [oh my zsh](https://ohmyz.sh/) if using zsh, `home/.zshrc` relies heavily on it
- change value of `$DOTFILES` in `home/.zshenv` to `.dotfiles` location (including its name), default to `~/.dotfiles`
- install these packages, marked (*) items are optional and replaceable:
    - [zsh](https://www.zsh.org/) (shell) (*)
    - [nemo](https://github.com/linuxmint/nemo/) (file explorer) (*)
    - [alacritty](https://alacritty.org/) (terminal emulator) (*)
    - [rofi](https://github.com/davatorium/rofi) (app launcher) (*)
    - [playerctl](https://github.com/altdesktop/playerctl) (control mpris2 based media)
    - imagemagick for `magick`
    - libnotify for `notify-send`
    - libpulse for pactl (pulseaudio) or wireplumber for wpctl (pipewire)  
    `yay -S zsh nemo alacritty rofi playerctl libnotify libpulse`
- i don't use `bash` anymore so `home/.bashrc` maybe outdated compared to `home/.zshrc`
- these are fonts and cursor theme used by default
    - cascadia-code-nerd
    - roboto
    - bibata-cursor-theme  
    `yay -S ttf-cascadia-code-nerd ttf-roboto bibata-cursor-theme`
- the gtk theme is not included because i use [oomox](https://github.com/themix-project/oomox-gtk-theme) to generate it (config will be added later)
> [!NOTE]
> i don't use any display manager, the window manager will run automatically after logging in the tty (see `home/.zprofile` on how to do that)
### awesomewm
these dependencies are only needed for awesomewm.
- [awesome](https://awesomewm.org/)
- [picom](https://github.com/yshui/picom)
- [maim](https://github.com/naelstrof/maim)
- [xclip](https://github.com/astrand/xclip)  
`yay -S awesome-git picom-git maim xclip`
### hyprland
these dependencies are only needed for hyprland.
- [hyprland](https://hyprland.org/)
- [hyprpaper](https://github.com/hyprwm/hyprpaper)
- [fabric](https://wiki.ffpy.org/)
- [wl-clipboard](https://github.com/bugaevc/wl-clipboard)
- [grim](https://sr.ht/~emersion/grim/) and [slurp](https://github.com/emersion/slurp)  
`yay -S hyprland hyprpaper wl-clipboard grim slurp`
## install
`create-symlink` will create symlinks of `.bin`, `home` children and `.config` children and place them to `~/.bin`, `~/` and `~/.config` in that order. you may not need to run it if you prefer doing it manually. remember to backup your file before doing this as they may be lost in the process.
```
git clone https://github.com/mncc8337/.dotfiles.git --recurse-submodules
.dotfiles/tool/create-symlink
```
