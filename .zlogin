#!/usr/bin/env zsh

# .zlogin is for login shells. It is sourced on the start of a login shell but after .zshrc, if the shell is 
# also interactive. This file is often used to start X using startx. Some systems start X on boot, so this 
# file is not always very useful.

{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# if [[ ! -v BW_SESSION ]]
# then
# 	export BW_SESSION=$(bw unlock --raw)
# fi
