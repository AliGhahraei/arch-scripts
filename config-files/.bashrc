# Si no estamos corriendo de forma interactiva, no hacemos nada
[[ $- != *i* ]] && return

# Include common aliases
[[ -f ~/.profile ]] && source ~/.profile

export PS1="\[\e[1;32m\]\[\e[4m\]\u\[\e[m\]\[\e[1;31m\]|\[\e[m\]\[\e[1;33m\]\[\e[m\]\[\e[1;36m\]\W\[\e[m\]\[\e[1;31m\]\$\[\e[m\] "
