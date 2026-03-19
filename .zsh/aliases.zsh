#!/usr/bin/env zsh

# Check if shai is installed before setting the shortcut
if command -v shai > /dev/null; then
    # Create the function to handle arguments
    \?() { shai "$*"; }

    # Use noglob so you can use characters like * or ? in your prompt
    # without the shell trying to find matching files first.
    alias "?"='noglob ?'
fi

# if command -v bat > /dev/null; then
#     alias cat="bat"
# fi

# if command -v ag > /dev/null; then
#     alias grep="ag"
# fi

# alias git-remote-keybase="git-remote-keybase.exe"

if command -v policy_sentry > /dev/null; then
    alias psn='policy_sentry'
fi

if command -v podman > /dev/null; then
    alias docker='podman'
fi

if command -v lsd > /dev/null; then
    alias ls='lsd'
    alias l='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
    alias lt='ls --tree'

    # list recent: lsd -l sorted by modified desc, top n (default 10)
    # usage: lr [path] [n]
    lr() {
        local path="."
        local n=10
        for arg in "$@"; do
            if [[ "$arg" =~ ^[0-9]+$ ]]; then
                n="$arg"
            else
                path="$arg"
            fi
        done
        /opt/homebrew/bin/lsd -lt "$path" | /usr/bin/head -n "$n"
    }
fi

if command -v bat > /dev/null; then
    alias less='bat'

    if command -v fzf > /dev/null; then
        # Wrap fzf with a bat preview, while still forwarding all args.
        # Use `whence -p` to bypass aliases/functions and resolve the real binaries.
        unalias fzf 2>/dev/null
        function fzf() {
            local fzf_bin bat_bin
            fzf_bin="$(whence -p fzf)" || return $?
            bat_bin="$(whence -p bat)" || return $?

            # Prefer fd for file listing (fast + good ignore support), otherwise fall back to ripgrep.
            local default_cmd
            if command -v fd > /dev/null; then
                default_cmd="fd --type f --follow --hidden \
                    --exclude .git --exclude .venv --exclude node_modules --exclude .terraform \
                    --exclude bin --exclude obj"
            else
                default_cmd="rg --files --follow --hidden \
                    -g '!.git/*' -g '!**/.venv/*' -g '!**/node_modules/*' -g '!**/.terraform/*' \
                    -g '!**/bin/*' -g '!**/obj/*'"
            fi

            FZF_DEFAULT_COMMAND="$default_cmd" \
            "$fzf_bin" \
                --preview "$bat_bin --color=always --style=numbers --line-range=:500 {}" \
                "$@"
        }
    fi
fi

if command -v gh > /dev/null; then
    alias pr='gh pr view --web'
    alias repo='gh browse'

    actions() {
        open "$(gh repo view --json url | jq -r '.url')/actions"
    }

    action() {
        local json
        local displayTitle
        local databaseId
        local createdAt
        local updatedAt
        local headSha
        local url
        json="$(gh run list --limit 1 --user "${GITHUB_USERNAME:?You need to setup GITHUB_USERNAME env var}" --json status,createdAt,updatedAt,url,displayTitle,headSha,databaseId)"
        displayTitle="$(echo "$json" | jq -r '.[0].displayTitle')"
        echo "$json"
        echo "$displayTitle"
        # TODO: I'd like to use gh run list to see if the most recent run from GITHUB_USERNAME is either running or completed. If it's running, I'd like to basically
        #       watch it and then call this with details from the json payload above. I was struggling to  grab displayTitle type fields from the json blob:
        # terminal-notifier -message test -contentImage 'https://github.githubassets.com/assets/github-logo-55c5b9a1fe52.png' -open "$(gh run list --limit 1 --user scottt732 --json status,createdAt,updatedAt,url,displayTitle,headSha,databaseId | jq -r '.[0].url')" -title Github Actions -subtitle ""
    }
fi

if command -v git > /dev/null; then
    # I hate bluetooth keyboards
    function gitc() {
      if [[ "$1" == ommit ]]; then
        shift
        git commit "$@"
      fi
    }

    # I hate bluetooth keyboards
    function gitp() {
      case "$1" in
        ull)
          shift
          git pull "$@"
          ;;
        ush)
          shift
          git push "$@"
          ;;
        *)
          # Fallback — if you just typed `gitp` or something else
          echo "Unknown subcommand. Did you mean:"
          echo "  gitp ull → git pull"
          echo "  gitp ush → git push"
          ;;
      esac
    }

    # I hate bluetooth keyboards
    function gits() {
      if [[ "$1" == tatus ]]; then
        shift
        git status "$@"
      fi
    }
fi

if command -v kubectl > /dev/null; then
    function kubeprodlegacy() {
        if [ $# -eq 0 ]; then
            aws eks update-kubeconfig --name cosmos-prod-cluster --profile=cosmos-prod --region=us-east-1 --alias cosmos-prod-legacy
        else
            kubectl $@ --context cosmos-prod-legacy
        fi
    }

    function kubedevlegacy() {
        if [ $# -eq 0 ]; then
            aws eks update-kubeconfig --name cosmos-dev-cluster --profile=cosmos-dev --region=us-east-1 --alias cosmos-dev-legacy
        else
            kubectl $@ --context cosmos-dev-legacy
        fi
    }

    function kubeprod() {
        if [ $# -eq 0 ]; then
            aws eks update-kubeconfig --name cosmos-prod-blue-us-east-1 --profile=cosmos-prod --region=us-east-1 --alias cosmos-prod-blue
        else
            kubectl $@ --context cosmos-prod-blue
        fi
    }

    function kubedev() {
        if [ $# -eq 0 ]; then
            aws eks update-kubeconfig --name cosmos-dev-blue-us-east-1 --profile=cosmos-dev --region=us-east-1 --alias cosmos-dev-blue
        else
            kubectl $@ --context cosmos-dev-blue
        fi
    }

    function kubemgmt() {
        if [ $# -eq 0 ]; then
            aws eks update-kubeconfig --name cosmos-mgmt-blue-us-east-1 --profile cosmos-mgmt --alias cosmos-mgmt-blue
        else
            kubectl $@ --context cosmos-mgmt-blue
        fi
    }

    # function kk() {
    #     kubectl kustomize --load-restrictor=LoadRestrictionsNone --enable-helm $@
    # }

    alias k8s-show-ns="kubectl api-resources --verbs=list --namespaced -o name  | xargs -n 1 kubectl get --show-kind --ignore-not-found -n"
fi

alias standup="(cd ~/cosmos/cosmos-eng && ./eng.py) | pbcopy && echo 'Check your clipboard'"
alias wai="git add :/ && git gen-commit ; git push && sleep 3 || true ; gh run watch || true"
alias wip="git add :/ && git commit -m 'wip' && git push && sleep 3 || true ; gh run watch || true"
# alias fzf="f() { $(whereis -bq fzf) --preview \"$(whereis -bq bat) --color=always --style=numbers --line-range=:500 {}\" $@};f"
alias findex="f() { find $@ -exec bat {} + };f"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

push() {
  # If there is an external `push` command, use it.
  if (( $+commands[push] )); then
    command push "$@"
    return $?
  fi

  # Fallback behavior (your old implementation)
  local message="${*:-push}"
  git add :/
  git commit -m "$message"
  git pull --rebase && git push && git lg -n 1
}

tail() { /usr/bin/tail $@ | bat --paging=never -l log }

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
    # git config aliases (lg, merged, stashes, rerere) are in ~/.gitconfig — no need to set on every shell start
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

# claude() {
#   ~/cosmos/cosmos-cli/scripts/claude "$@"
# }

# Warp directory navigation - replacement for wd plugin
wd() {
   local warprc="$HOME/.warprc"
  
  # Create warprc if it doesn't exist for add command
  if [[ "$1" == "add" ]]; then
    if [[ -z "$2" ]]; then
      echo "Usage: wd add <name>"
      return 1
    fi
    # Create file if it doesn't exist
    [[ ! -f "$warprc" ]] && touch "$warprc"
    # Check if name already exists
    if grep -q "^$2:" "$warprc" 2>/dev/null; then
      echo "Warp point '$2' already exists. Remove it first with 'wd rm $2'"
      return 1
    fi
    # Add new warp point with ~ for home directory
    local save_path="${PWD/#$HOME/~}"
    echo "$2:$save_path" >> "$warprc"
    echo "Warp point '$2' added → $save_path"
    return 0
  fi
  
  if [[ ! -f "$warprc" ]]; then
    echo "Error: $warprc not found"
    return 1
  fi
  
  if [[ "$1" == "list" ]]; then
    echo "Available warp points:"
    while IFS=':' read -r name warp_path; do
      [[ -z "$name" ]] && continue
      printf "  %-8s → %s\n" "$name" "$warp_path"
    done < "$warprc"
    return 0
  fi
  
  if [[ -z "$1" ]]; then
    echo "Usage: wd <warp_point>"
    echo "       wd add <name>"
    echo "       wd list"
    return 1
  fi
  
  local target_path
  while IFS=':' read -r name warp_path; do
    if [[ "$name" == "$1" ]]; then
      target_path="${warp_path/#\~/$HOME}"
      break
    fi
  done < "$warprc"
  
  if [[ -n "$target_path" ]]; then
    # If in iTerm2 with tmux integration mode, attach directly to session
    if [[ -n "$ITERM_SESSION_ID" && -n "$TMUX" ]]; then
      local session_name=$(basename "$target_path")
      # Create new session or attach to existing one
      tmux -CC new-session -A -s "$session_name" -c "$target_path"
    else
      # Normal cd behavior when not in tmux integration mode
      cd "$target_path"
    fi
  else
    echo "Unknown warp point: $1"
    echo "Use 'wd list' to see available warp points"
    return 1
  fi
}

alias current=openCurrent
alias upcoming=openUpcoming
alias mine=openMine
alias standup-ui=openStandup

# Helper to manually refresh when needed
claude-refresh() {
  echo "🔄 Manually refreshing AWS credentials..."
  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  aws sso login --profile cosmos-mgmt
  eval "$(aws configure export-credentials --profile cosmos-mgmt --format env)"
  echo "✅ Ready for claude!"
}
