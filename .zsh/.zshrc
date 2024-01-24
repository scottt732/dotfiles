autoload -Uz compinit
compinit

# OS-specific
if [[ $(uname) == "Darwin" ]]; then
    export ZSH_OS="mac"
    if [[ -f "${ZDOTDIR}/os/mac/import.zsh" ]]; then
        source "${ZDOTDIR}/os/mac/import.zsh"
    fi
elif command -v freebsd-version > /dev/null; then
    export ZSH_OS="freebsd"
    if [[ -f "${ZDOTDIR}/os/freebsd/import.zsh" ]]; then
        source "${ZDOTDIR}/os/freebsd/import.zsh"
    fi
elif command -v apt > /dev/null; then
    export ZSH_OS="debian"
    if [[ -f "${ZDOTDIR}/os/debian/import.zsh" ]]; then
        source "${ZDOTDIR}/os/debian/import.zsh"
    fi
fi

# WSL
if [[ -f '/proc/sys/fs/binfmt_misc/WSLInterop' ]]; then
    export ZSH_WSL="true"
    if [[ -f "${ZDOTDIR}/wsl/import.zsh" ]]; then
        source "${ZDOTDIR}/wsl/import.zsh"
    fi
fi

# systemd
if command -v systemctl > /dev/null; then
    export ZSH_SYSTEMD="true"
    if [[ -f "${ZDOTDIR}/systemd/import.zsh" ]]; then
        source "${ZDOTDIR}/systemd/import.zsh"
    fi
fi

# Docker
if command -v docker > /dev/null; then
    export ZSH_DOCKER="true"
    if [[ -f "${ZDOTDIR}/docker/import.zsh" ]]; then
        source "${ZDOTDIR}/docker/import.zsh"
    fi
fi

# Kubernetes
if command -v kubectl > /dev/null; then
    export ZSH_K8S="true"
    if [[ -f "${ZDOTDIR}/k8s/import.zsh" ]]; then
        source "${ZDOTDIR}/k8s/import.zsh"
    fi
fi

# tmux
if command -v tmux > /dev/null; then
    export ZSH_TMUX="true"
    if [[ -f "${ZDOTDIR}/tmux/import.zsh" ]]; then
        source "${ZDOTDIR}/tmux/import.zsh"
    fi
fi

source "${ZDOTDIR}/antidote.zsh"
source "${ZDOTDIR}/direnv-ps10k.zsh"
source "${ZDOTDIR}/aliases.zsh"
source "${ZDOTDIR}/completions.zsh"
source "${ZDOTDIR}/functions.zsh"
