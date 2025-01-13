# change this to your dotfiles location
export DOTFILES=~/.dotfiles

export PATH="$HOME/.bin:$HOME/.local/bin:"$PATH
export VISUAL=nvim
export EDITOR="$VISUAL"
export MANPAGER="nvim +Man!"

# sometime git commit failed so
export GPG_TTY=$(tty)

export PYTHONDONTWRITEBYTECODE=1
