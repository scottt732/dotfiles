# .zlogin is for login shells. It is sourced on the start of a login shell but after .zshrc, if the shell is 
# also interactive. This file is often used to start X using startx. Some systems start X on boot, so this 
# file is not always very useful.
# avoid auto-renice of bg jobs (prevents line 8 warning)
unsetopt BG_NICE

# if you still want a best-effort niceness check, make it valid
nice -n 5 true >/dev/null 2>&1 || true

{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} >/dev/null 2>&1 &!
