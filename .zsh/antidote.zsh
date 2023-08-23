zsh_plugins="$ZDOTDIR/.zsh_plugins.zsh"
[[ -f ${zsh_plugins:r}.txt ]] || touch ${zsh_plugins:r}.txt
fpath+=($ZDOTDIR/.antidote)
autoload -Uz $fpath[-1]/antidote

if [[ ! $zsh_plugins -nt ${zsh_plugins:r}.txt ]]; then
  (antidote bundle <${zsh_plugins:r}.txt >|$zsh_plugins)
fi
source $zsh_plugins
