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

plugins=(fzf zoxide zsh-autosuggestions zsh-syntax-highlighting git)

source $ZSH/oh-my-zsh.sh

# User configuration

# fix zsh-syntax-highlighter black out comments and variable calling `$var`
# ZSH_HIGHLIGHT_STYLES[comment]='fg=cyan,bold'

alias py="python3"
alias mv="mv -v"
alias cp="cp -v"
alias rm="rm -v"

source ~/.zsh_functions

# only print this if not inside a tty
if [ -z "$(tty | grep tty)" ]; then
    crunchbang-mini
fi
