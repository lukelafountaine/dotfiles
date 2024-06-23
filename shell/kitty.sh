alias icat="kitty +kitten icat"

if [[ "${TERM}" == "xterm-kitty" ]]; then
   THEME_UPDATER_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)/../../private-dotfiles/scripts/update-theme.sh"

   export PROMPT_COMMAND="source ${THEME_UPDATER_PATH}; ${PROMPT_COMMAND}"
fi
