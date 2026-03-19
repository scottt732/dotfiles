# direnv + p10k instant prompt integration
# Must be first — direnv output happens before p10k captures stdout
source "${ZDOTDIR}/direnv-ps10k.zsh"

HISTSIZE=1000
HISTFILE="${HOME}/.zhistory"
SAVEHIST=1000
setopt INC_APPEND_HISTORY

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

# Docker CLI completions (fpath must be set before compinit)
fpath=(/Users/sholodak/.docker/completions $fpath)

# Single compinit — cached, rebuilds once per day
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

source "${ZDOTDIR}/antidote.zsh"
source "${ZDOTDIR}/aliases.zsh"
source "${ZDOTDIR}/functions.zsh"

# fnm
FNM_PATH="/Users/sholodak/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/sholodak/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi

export SHELL=/bin/zsh

. "$HOME/.local/bin/env"

# bun completions
[ -s "/Users/sholodak/.bun/_bun" ] && source "/Users/sholodak/.bun/_bun"

# PATH additions (deduplicated)
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="$PATH:/Users/sholodak/.cache/lm-studio/bin"
export PATH="/Users/sholodak/.antigravity/antigravity/bin:$PATH"
export PATH=/Users/sholodak/.opencode/bin:$PATH

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Cached completions (run `regen-completions` to refresh)
source "${ZDOTDIR}/completions.zsh"
