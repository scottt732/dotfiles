# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz compinit
compinit

HISTSIZE=1000
HISTFILE="${HOME}/.zhistory"
SAVEHIST=1000
setopt INC_APPEND_HISTORY

if command -v git > /dev/null; then
    git config --global user.email "scottt732@gmail.com"
    git config --global user.name "Scott Holodak"
fi

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

# To customize prompt, run `p10k configure` or edit ~/.zsh/.p10k.zsh.
[[ ! -f ~/.zsh/.p10k.zsh ]] || source ~/.zsh/.p10k.zsh
