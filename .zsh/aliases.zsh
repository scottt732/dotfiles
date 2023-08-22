#!/usr/bin/env zsh

if command -v bat > /dev/null; then
    alias cat="bat"
fi

if command -v ag > /dev/null; then
    alias grep="ag"
fi

if command -v docker > /dev/null; then
    alias dl="f() { docker logs --tail 1 --follow $1 };f"
    alias dr="f() { docker stop $1 && docker start $1 };f"
    alias drl="f() { docker stop $1 && docker start $1 && docker logs --tail 1 --follow $1 };f"
    alias dsr="f() { docker stop $1 && docker rm $1 };f"
fi

alias git-remote-keybase="git-remote-keybase.exe"
