#!/usr/bin/env zsh

# Cached completions — each command's completion output is saved to a file
# and only regenerated when missing. Run `regen-completions` to force refresh.

ZSH_COMPL_CACHE="${ZDOTDIR}/.zcompl-cache"
[[ -d "$ZSH_COMPL_CACHE" ]] || mkdir -p "$ZSH_COMPL_CACHE"

_cached_source() {
    local name="$1" cache_file="$ZSH_COMPL_CACHE/_$1"
    shift
    if [[ ! -f "$cache_file" ]]; then
        "$@" > "$cache_file" 2>/dev/null || { rm -f "$cache_file"; return 1; }
    fi
    source "$cache_file"
}

regen-completions() {
    rm -rf "$ZSH_COMPL_CACHE"
    mkdir -p "$ZSH_COMPL_CACHE"
    echo "Completion cache cleared. Restart your shell to regenerate."
}

# dotnet
_dotnet_zsh_complete() {
  local completions=("$(dotnet complete "$words")")
  reply=( "${(ps:\n:)completions}" )
}
compctl -K _dotnet_zsh_complete dotnet

# Tool completions (cached)
(( $+commands[argocd] ))    && _cached_source argocd    argocd completion zsh
(( $+commands[helm] ))      && _cached_source helm      helm completion zsh
(( $+commands[kubectl] ))   && _cached_source kubectl   kubectl completion zsh
(( $+commands[kubeadm] ))   && _cached_source kubeadm   kubeadm completion zsh
(( $+commands[istioctl] ))  && _cached_source istioctl  istioctl completion zsh
(( $+commands[gitops] ))    && _cached_source gitops    gitops completion zsh
(( $+commands[flux] ))      && _cached_source flux      flux completion zsh
(( $+commands[gh] ))        && _cached_source gh        gh completion -s zsh
(( $+commands[openclaw] ))  && _cached_source openclaw  openclaw completion --shell zsh
(( $+commands[entire] ))    && _cached_source entire    entire completion zsh

# pyenv (lazy — only init when first called)
if (( $+commands[pyenv] )); then
    pyenv() {
        unfunction pyenv
        eval "$(command pyenv init -)"
        pyenv "$@"
    }
fi

# yarn global bin (cached to avoid slow subprocess)
if (( $+commands[yarn] )); then
    local _yarn_cache="$ZSH_COMPL_CACHE/_yarn_global_bin"
    if [[ ! -f "$_yarn_cache" ]]; then
        command yarn global bin > "$_yarn_cache" 2>/dev/null
    fi
    [[ -f "$_yarn_cache" ]] && export PATH="$PATH:$(<$_yarn_cache)"
fi

# policy_sentry
if (( $+commands[policy_sentry] )); then
    local _ps_cache="$ZSH_COMPL_CACHE/_policy_sentry"
    if [[ ! -f "$_ps_cache" ]]; then
        _POLICY_SENTRY_COMPLETE=zsh_source policy_sentry > "$_ps_cache" 2>/dev/null
    fi
    [[ -f "$_ps_cache" ]] && source "$_ps_cache"
fi
