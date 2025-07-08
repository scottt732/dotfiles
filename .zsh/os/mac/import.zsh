eval "$(/opt/homebrew/bin/brew shellenv)"
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# set iterm2 title
function title {
    echo -ne "\033]0;"$*"\007"
    printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "$*" | base64)
}
