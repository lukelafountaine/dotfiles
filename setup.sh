#!/bin/bash

REPO_PATH=$(cd "$(dirname "$0")" && pwd)

#################################################
# Set Homebrew environment variables
#################################################
BREW_SETTINGS_PATH="${REPO_PATH}/shell/brew.sh"

[ -f /opt/homebrew/bin/brew ] && BREW="/opt/homebrew/bin/brew" || BREW="/usr/local/bin/brew"
if ! grep -q "shellenv" "${BREW_SETTINGS_PATH}"; then
   echo "INFO: Setting Homebrew environment variables"
   echo 'eval "$('${BREW}' shellenv)"' >> "${BREW_SETTINGS_PATH}"
fi

#################################################
# Create symlinks for config
#################################################

function create_config_link {
   CONFIG_FILE=$1
   CONFIG_SOURCE=$2

   echo "INFO: Linking: ${CONFIG_FILE}"

   if [ -h "$CONFIG_FILE" ]; then
      echo "WARNING: '${CONFIG_FILE}' already seems to be symlinked, taking no action."
   elif [ -d "$CONFIG_FILE" ]; then
      echo "ERROR: A config directory already exists at '${CONFIG_FILE}', taking no action."
   elif [ -f "$CONFIG_FILE" ]; then
      echo "ERROR: A config file already exists at '${CONFIG_FILE}', taking no action."
   else
      echo "INFO: Creating symlink to: ${CONFIG_SOURCE}"
      ln -s "${CONFIG_SOURCE}" "${CONFIG_FILE}"
   fi
}

create_config_link "${HOME}/.aws/cli/alias" "${REPO_PATH}/aws_aliases"
create_config_link "${HOME}/.awsume/config.yaml" "${REPO_PATH}/awsume_config"
create_config_link "${HOME}/.Brewfile" "${REPO_PATH}/Brewfile"
create_config_link "${HOME}/.bash_profile" "${REPO_PATH}/bash_profile"
create_config_link "${HOME}/.bashrc" "${REPO_PATH}/bashrc"
create_config_link "${HOME}/.config/helix" "${REPO_PATH}/helix"
create_config_link "${HOME}/.config/kitty" "${REPO_PATH}/kitty"
create_config_link "${HOME}/.config/karabiner/karabiner.json" "${REPO_PATH}/karabiner.json"
create_config_link "${HOME}/.duckdbrc" "${REPO_PATH}/duckdbrc"
create_config_link "${HOME}/.dprint.json" "${REPO_PATH}/dprint.json"
create_config_link "${HOME}/.gitconfig" "${REPO_PATH}/gitconfig"
create_config_link "${HOME}/.gitignore_global" "${REPO_PATH}/gitignore_global"
create_config_link "${HOME}/.inputrc" "${REPO_PATH}/inputrc"
create_config_link "${HOME}/.nvmrc" "${REPO_PATH}/nvmrc"
create_config_link "${HOME}/.tmux.conf" "${REPO_PATH}/tmux.conf"
create_config_link "${HOME}/.vim" "${REPO_PATH}/vim/vim"
create_config_link "${HOME}/.vimrc" "${REPO_PATH}/vim/vimrc"
create_config_link "${HOME}/Library/Application Support/Code/User/keybindings.json" "${REPO_PATH}/vs-code/keybindings.json"
create_config_link "${HOME}/Library/Application Support/Code/User/settings.json" "${REPO_PATH}/vs-code/settings.json"
