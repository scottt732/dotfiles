#!/usr/bin/env zsh

# What OS are we running?
if [[ $(uname) == "Darwin" ]]; then
    export ZSH_OS="mac"
    source "${ZDOTDIR}/os/mac.zsh"
elif command -v apt > /dev/null; then
    export ZSH_OS="debian"
    source "${ZDOTDIR}/os/debian.zsh"
fi

if command -v systemctl > /dev/null; then
    source "${ZDOTDIR}/systemd.zsh"
fi

if command -v docker > /dev/null; then
    source "${ZDOTDIR}/docker.zsh"
fi

if command -v kubectl > /dev/null; then
    source "${ZDOTDIR}/k8s.zsh"
fi

source "${ZDOTDIR}/aliases.zsh"
source "${ZDOTDIR}/completions.zsh"
