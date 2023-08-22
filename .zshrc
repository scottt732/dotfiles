#!/usr/bin/env zsh

# .zshrc is for interactive shells. You set options for the interactive shell there with the setopt and unsetopt commands. 
# You can also load shell modules, set your history options, change your prompt, set up zle and completion, et cetera. You 
# also set any variables that are only used in the interactive shell (e.g. $LS_COLORS).

[[ -z "$TMUX" && -n "$USE_TMUX" ]] && {
    [[ -n "$ATTACH_ONLY" ]] && {
        tmux a 2>/dev/null || {
            cd && exec tmux
        }
        exit
    }

    tmux new-window -c "$PWD" 2>/dev/null && exec tmux a
    exec tmux
}

source "${ZDOTDIR}/import.zsh"

source "$ZANTIDOTEDIR/antidote.zsh"
antidote load $ZDOTDIR/.zsh_plugins.txt

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"
