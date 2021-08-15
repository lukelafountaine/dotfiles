#!/bin/bash

REPO_PATH=$(cd "$(dirname "$0")" && pwd)

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

create_config_link "${HOME}/.bash_profile" "${REPO_PATH}/bash_profile"
create_config_link "${HOME}/.bashrc" "${REPO_PATH}/bashrc"
create_config_link "${HOME}/.gitconfig" "${REPO_PATH}/gitconfig"
create_config_link "${HOME}/.gitignore_global" "${REPO_PATH}/gitignore_global"
create_config_link "${HOME}/.inputrc" "${REPO_PATH}/inputrc"
create_config_link "${HOME}/.nvmrc" "${REPO_PATH}/nvmrc"
create_config_link "${HOME}/.vim" "${REPO_PATH}/vim/vim"
create_config_link "${HOME}/.vimrc" "${REPO_PATH}/vim/vimrc"
create_config_link "${HOME}/Library/Application Support/Code/User/keybindings.json" "${REPO_PATH}/vs-code/keybindings.json"
create_config_link "${HOME}/Library/Application Support/Code/User/settings.json" "${REPO_PATH}/vs-code/settings.json"
