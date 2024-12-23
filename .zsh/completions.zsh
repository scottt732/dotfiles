#!/usr/bin/env zsh

_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet

if [ $(command -v argocd) ]; then
  source <(argocd completion zsh)
fi

if [ $(command -v helm) ]; then
  source <(helm completion zsh)
fi

if [ $(command -v kubectl) ]; then
  source <(kubectl completion zsh)
fi

if [ $(command -v kubeadm) ]; then
  source <(kubeadm completion zsh)
fi

if [ $(command -v istioctl) ]; then
  source <(istioctl completion zsh)
fi

if [ $(command -v gitops) ]; then
  source <(gitops completion zsh)
fi

if [ $(command -v flux) ]; then
  source <(flux completion zsh)
fi

if [ $(command -v gh) ]; then
  source <(gh completion -s zsh)
fi

if [ $(command -v pyenv) ]; then
  eval "$(pyenv init -)"
fi

if [ $(command -v yarn) ]; then
  export PATH="$PATH:$(yarn global bin)"
fi
