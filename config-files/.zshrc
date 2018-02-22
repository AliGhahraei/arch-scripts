[[ -r ~/.profile ]] && source ~/.profile

fpath=( "$HOME/.zfunctions" $fpath )

# Antibody
source ~/.zsh_plugins.sh

###########
# Plugins #
###########

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
