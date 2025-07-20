SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Bash history settings
# https://twitter.com/gumnos/status/1117146713289121797?s=11
export HISTCONTROL=ignorespace:erasedups
export HISTIGNORE=ls:cd:pwd:
export HISTSIZE=
export HISTFILESIZE=
shopt -s histappend # Append to the history file, don't overwrite it

# Environment
export EDITOR=hx
export PAGER=less
export LESS="-RinSFX"

# Silence message saying zsh is the new default shell
export BASH_SILENCE_DEPRECATION_WARNING=1

# Aliases to configure default options
alias diff="colordiff"
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias ag="ag --pager=less"

# General aliases
alias c="clear"
alias ll='ls -lah'
alias 4up="cd ../../../.."
alias 3up="cd ../../.."
alias 2up="cd ../.."

# Load external helpers
source "${SCRIPT_DIR}/brew.sh"
source "${SCRIPT_DIR}/fzf.sh"
source "${SCRIPT_DIR}/path.sh"
source "${SCRIPT_DIR}/prompt.sh"
source "${SCRIPT_DIR}/utilities.sh"
source "${SCRIPT_DIR}/aws.sh"
source "${SCRIPT_DIR}/nvm.sh"
source "${SCRIPT_DIR}/kitty.sh"
source "${SCRIPT_DIR}/zoxide.sh"
