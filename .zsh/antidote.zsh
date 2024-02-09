ZSH_PLUGINS_ZSH="$ZDOTDIR/.zsh_plugins.zsh"
ZSH_PLUGINS_TXT="${ZSH_PLUGINS_ZSH:r}.txt"

if [[ ! -f "$ZANTIDOTEDIR/antidote.zsh" ]]; then
  # Get Antidote
  git clone --depth=1 https://github.com/mattmc3/antidote.git $ZANTIDOTEDIR
fi

[[ -f "$ZSH_PLUGINS_TXT" ]] || touch "$ZSH_PLUGINS_TXT"

fpath+=($ZDOTDIR/.antidote)
autoload -Uz $fpath[-1]/antidote

if [[ ! "$ZSH_PLUGINS_ZSH" -nt "$ZSH_PLUGINS_TXT" ]]; then
  (antidote bundle <"$ZSH_PLUGINS_TXT" >|"$ZSH_PLUGINS_ZSH")
fi

source "$ZSH_PLUGINS_ZSH"

# zsh-history-substring-search configuration
# see https://github.com/zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up # or '\eOA'
bindkey '^[[B' history-substring-search-down # or '\eOB'
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

autoload -U colors; colors
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'
