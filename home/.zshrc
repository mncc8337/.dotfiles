export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="gianu" # murilasso dst duellj gianu

# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"

# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# zstyle ':omz:update' frequency 15

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="false"

# DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="mm/dd/yyyy"

ENABLE_CORRECTION=true

# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(fzf zoxide zsh-syntax-highlighting git vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

# vi-mode settings
MODE_INDICATOR="%F{red}[N]%f"
INSERT_MODE_INDICATOR="%F{green}[I]%f"
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_NORMAL=2
VI_MODE_CURSOR_VISUAL=2
VI_MODE_CURSOR_INSERT=6
VI_MODE_CURSOR_OPPEND=0
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
done

# fix zsh-syntax-highlighter black out comments and variable calling `$var`
# ZSH_HIGHLIGHT_STYLES[comment]='fg=cyan,bold'

alias py="python3"
alias mv="mv -v"
alias cp="cp -v"
alias rm="rm -v"
alias news="yay -Pw"

source ~/.zsh_functions

# only print this if not inside a tty
if [ -z "$(tty | grep tty)" ]; then
    crunchbang-mini
fi
