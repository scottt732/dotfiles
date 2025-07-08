# .zshenv is always sourced. It often contains exported variables that should be available to other programs. For example, $PATH, $EDITOR, and $PAGER 
# are often set in .zshenv. Also, you can set $ZDOTDIR in .zshenv to specify an alternative location for the rest of your zsh configuration.

# Defines Environment Variables
if [ -d "/snap/bin" ] ; then
  export PATH="/snap/bin:$PATH"
fi

if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

# RESET ZSHENV FILE VIA ENVIRONMENT VARIABLE
# export USR_ZSHENV_PATH="$HOME/.zshenv"
# if [[ $USR_ZSHENV_RESET -eq 1 ]]; then
#   unset USR_ZSHENV_RESET

#   git clone https://gist.github.com/$GIST_USR_ZSHENV_ID "$TEMP_GIST"
#   mv "$USR_ZSHENV_PATH" "$USR_ZSHENV_PATH.bak"
#   cp "$TEMP_GIST/.zshenv" "$USR_ZSHENV_PATH"
#   . "$USR_ZSHENV_PATH"
# fi

# DIRECTORIES
export ZANTIDOTEDIR="${ZDOTDIR:?}/.antidote"
export ZPERSONALDIR="${ZANTIDOTEDIR:?}/.personal"
export ZWORKDIR="${ZANTIDOTEDIR:?}/.work"
export ZLOCALBIN="$HOME/.local/bin"
export ZGITDIR="${ZDOTDIR:?}/git"

mkdir -p "$ZLOCALBIN"
export PATH="${PATH}:${ZLOCALBIN}"

if [ -d /usr/local/go ]; then
  export PATH="${PATH}:/usr/local/go/bin"
fi

# Mac OS X uses path_helper and /etc/paths.d to preload PATH, clear it out first
if [ -x /usr/libexec/path_helper ]; then
  PATH=''
  eval `/usr/libexec/path_helper -s`
fi

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "$ZPROFILE_PATH" ]]; then
  . "$ZPROFILE_PATH"
fi

# while [[ -z "$BW_SESSION" ]] && command -v bw > /dev/null; do
#   export BW_SESSION=$(bw unlock --raw)
# done;

export BAT_CONFIG_PATH="${HOME}/.zshrc/bat.conf"
export PATH="${PATH}:${ZGITDIR}"
. "$HOME/.cargo/env"
