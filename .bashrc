#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

GREEN="\[\e[38;5;120m\]"
RESET="\[\e[0m\]"

#PS1='[\u@\h \W]\[\e[38;5;82m\]\$\[\e[0m\] '
PS1="${GREEN}[\u@\h \W]\$${RESET} "

export PATH=$PATH:$HOME/.local/bin

# Alias for operations on the ~/.nazdotfiles git repo
alias nazfig='/usr/bin/git --git-dir=$HOME/.nazfig_repo/ --work-tree=$HOME'
