#!/usr/bin/env zsh

if command -v bat > /dev/null; then
    alias cat="bat"
fi

# if command -v ag > /dev/null; then
#     alias grep="ag"
# fi

alias git-remote-keybase="git-remote-keybase.exe"

if command -v lsd > /dev/null; then
    alias ls='lsd'
    alias l='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
    alias lt='ls --tree'
fi

if command -v bat > /dev/null; then
    alias less='bat'
fi

alias fzf="f() { /usr/bin/fzf --preview \"bat --color=always --style=numbers --line-range=:500 {}\" $@};f"
alias findex="f() { find $@ -exec bat {} + };f"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

function tail() { tail $@ | bat --paging=never -l log }
