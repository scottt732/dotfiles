#!/usr/bin/env zsh

if command -v bat > /dev/null; then
    alias cat="bat"
fi

# if command -v ag > /dev/null; then
#     alias grep="ag"
# fi

alias git-remote-keybase="git-remote-keybase.exe"

if command -v lsd > /dev/null; then
    alias ls='lsd'
    alias l='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
    alias lt='ls --tree'
fi

if command -v bat > /dev/null; then
    alias less='bat'
fi

if command -v gh > /dev/null; then
    alias pr='gh pr view --web'
    alias repo='gh browse'
fi

if command -v kubectl > /dev/null; then
    alias kubeprod="aws eks update-kubeconfig --name cosmos-prod-cluster --profile=cosmos-prod --region=us-east-1"
    alias kubestaging="aws eks update-kubeconfig --name cosmos-staging-cluster --profile=cosmos-staging --region=us-east-1"
    alias kubedev="aws eks update-kubeconfig --name cosmos-dev-cluster --profile=cosmos-dev --region=us-east-1"
fi

alias fzf="f() { /usr/bin/fzf --preview \"bat --color=always --style=numbers --line-range=:500 {}\" $@};f"
alias findex="f() { find $@ -exec bat {} + };f"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

function tail() { /usr/bin/tail $@ | bat --paging=never -l log }

openTicket() {
  ticket=$(git branch --show-current | grep -oi 'eng-[0-9]\+')

  if [[ -z "$ticket" ]]; then
    echo "No ticket number found in the current branch name."
  else
    open "linear://thecosmos/issue/$ticket"
    # open "https://linear.app/thecosmos/issue/$ticket"
  fi
}

openCurrent() {
  open "linear://linear.app/thecosmos/view/49842653-9a9b-49dc-b0e4-13ce1eba414a"
}

openUpcoming() {
  open "linear://linear.app/thecosmos/view/b35afb44-a174-4284-8e28-51cabf15e527"
}

openMine() {
  open "linear://linear.app/thecosmos/view/9f54cc8b-61f6-4ae3-8983-a72fcdbbea0e"
}

if command -v git > /dev/null; then
    git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    git config --global alias.merged "branch --list '[^main|master|dev|staging|prod]*' -v --format='%(committerdate:short)  %(refname:short)' --sort=committerdate --merged"
    git config --global rerere.enabled true
    alias ticket=openTicket
fi

openCurrent() {
  open "linear://linear.app/thecosmos/view/49842653-9a9b-49dc-b0e4-13ce1eba414a"
}

openUpcoming() {
  open "linear://linear.app/thecosmos/view/b35afb44-a174-4284-8e28-51cabf15e527"
}

openMine() {
  open "linear://linear.app/thecosmos/view/9f54cc8b-61f6-4ae3-8983-a72fcdbbea0e"
}

openStandup() {
  open "linear://linear.app/thecosmos/view/3bb1afc7-573f-40f0-933b-fca76a899176"
}

alias current=openCurrent
alias upcoming=openUpcoming
alias mine=openMine
alias standup=openStandup
