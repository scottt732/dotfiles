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
