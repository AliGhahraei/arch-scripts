#!/usr/bin/env sh
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

message () {
   printf "${GREEN}$1${NO_COLOR}\n"
}

warning () {
   printf "${YELLOW}$1${NO_COLOR}\n"
}

err () {
   printf "${RED}$1${NO_COLOR}\n"
   exit 1
}

check_clean_tree () {
   builtin cd $1
   if [ -n "$(git status --porcelain)" ]; then
      warning "Commit your files! $1 tree was not clean."
   fi
}


if [[ $(uname) == 'Darwin' ]]; then
   message 'Upgrading brew...'
   brew update && brew upgrade && brew cask upgrade
else
   err 'Unsupported platform!'
fi

message 'Upgrading pip...'
pip3 list --format=freeze --outdated | cut -d = -f 1 | xargs -n1 pip3 install -U

message 'Upgrading fisher...'
./fisher_update.fish

message 'Checking git repos'
check_clean_tree ~/g/scripts
check_clean_tree ~/g/dotfiles

message 'Finished'
