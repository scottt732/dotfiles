#!/usr/bin/env zsh

# .zprofile is for login shells. It is basically the same as .zlogin except that it's sourced before .zshrc 
# whereas .zlogin is sourced after .zshrc. According to the zsh documentation, ".zprofile is meant as an 
# alternative to .zlogin for ksh fans; the two are not intended to be used together, although this could 
# certainly be done if desired.""

export HISTFILE="${HOME}/.zhistory"

if [ -f "${HOME}/.zprofile" ]; then
    echo "Loading profile"
    source "${HOME}/.zprofile"
fi

