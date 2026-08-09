#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Launch fish for interactive non-login shells
if ! shopt -q login_shell 2>/dev/null && command -v fish &> /dev/null; then
    exec fish
fi
