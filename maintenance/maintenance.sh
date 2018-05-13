#!/usr/bin/env sh
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
no_color='\033[0m'

current_dir=$( dirname "${BASH_SOURCE[0]}" )

message () {
   printf "${green}$1${no_color}\n"
}

warning () {
   printf "${yellow}$1${no_color}\n"
}

err () {
   printf "${red}$1!${no_color}\n"
   exit 1
}

check_clean_tree () {
   builtin cd $1
   if [ -n "$(git status --porcelain)" ]; then
      warning "Commit your files! $1 tree was not clean."
      return 1
   fi
}

pip_package_upgrade="pip3 list --format=freeze --outdated | cut -d = -f 1 | xargs -n1 pip3 install -U"
pip_upgrade="pip3 install --upgrade pip"

if [[ $(uname) == 'Darwin' ]]; then
   message 'Upgrading brew...'
   brew update && brew upgrade && brew cask upgrade

   message 'Upgrading pip...'
   eval "sudo -H $pip_package_upgrade"
   eval "sudo -H $pip_upgrade"
else
   err "Unsupported platform's package manager"

   message 'Upgrading pip...'
   eval "sudo $pip_package_upgrade"
   eval "sudo $pip_upgrade"
fi


message 'Upgrading shell...'
$current_dir/./fisher_update.fish

message 'Checking git repos'
clean_scripts=check_clean_tree ~/g/scripts
clean_dotfiles=check_clean_tree ~/g/dotfiles

if [[ $clean_scripts -eq 0  ]] && [[ $clean_dotfiles -eq 0 ]]; then
    message "Everything's clean!"
fi

message 'Launching backup tool'
open -a MEGAsync &

warning 'Remember to update Emacs manually'

message 'Finished'
