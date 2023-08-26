# .zshenv is always sourced. It often contains exported variables that should be available to other programs. For example, $PATH, $EDITOR, and $PAGER 
# are often set in .zshenv. Also, you can set $ZDOTDIR in .zshenv to specify an alternative location for the rest of your zsh configuration.

# Defines Environment Variables
if [ -d "/snap/bin" ] ; then
  export PATH="/snap/bin:$PATH"
fi

if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

export DOTNET_CLI_TELEMETRY_OPTOUT=1

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
export ZANTIDOTEDIR="$ZDOTDIR/.antidote"
export ZPERSONALDIR="$ZANTIDOTEDIR/.personal"
export ZWORKDIR="$ZANTIDOTEDIR/.work"
export ZLOCALBIN="$HOME/.local/bin"

mkdir -p "$ZLOCALBIN" 
export PATH="${PATH}:${ZLOCALBIN}"

# Mac OS X uses path_helper and /etc/paths.d to preload PATH, clear it out first
if [ -x /usr/libexec/path_helper ]; then
  PATH=''
  eval `/usr/libexec/path_helper -s`
fi

# Get Antidote
if [[ ! -d "$ZANTIDOTEDIR" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git $ZANTIDOTEDIR
fi

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "$ZPROFILE_PATH" ]]; then
  . "$ZPROFILE_PATH"
fi

# while [[ -z "$BW_SESSION" ]] && command -v bw > /dev/null; do
#   export BW_SESSION=$(bw unlock --raw)
# done;
