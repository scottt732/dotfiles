if [[ $(uname) == "Darwin" ]]; then
    export ZSH_OS="mac"
    source "${ZDOTDIR}/os/mac/import.zsh"
elif command -v freebsd-version > /dev/null; then
    export ZSH_OS="freebsd"
    source "$ZSH_CUSTOM/os/freebsd/import.zsh"
elif command -v apt > /dev/null; then
    export ZSH_OS="debian"
    source "${ZDOTDIR}/os/debian/import.zsh"
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

source "${ZDOTDIR}/antidote.zsh"
source "${ZDOTDIR}/direnv-ps10k.zsh"
source "${ZDOTDIR}/aliases.zsh"
source "${ZDOTDIR}/completions.zsh"
