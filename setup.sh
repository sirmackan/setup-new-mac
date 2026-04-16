#!/usr/bin/env bash
set -euo pipefail
set -x

softwareupdate --install-rosetta --agree-to-license

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install --cask google-chrome ghostty slack jetbrains-toolbox visual-studio-code dockdoor raycast docker-desktop caddy antigravity codex claude-code
brew install go pure zsh-history-substring-search uv gemini-cli

go install mvdan.cc/gofumpt@latest

uv python install
uv python update-shell

https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

git config --global push.autoSetupRemote true
git config --global alias.bp "pull --rebase --autostash"

touch ~/.hushlogin
mkdir -p ~/tmp ~/git ~/.config/ghostty

cat > ~/.config/ghostty/config <<'EOF'
theme = Snazzy
window-width = 120
window-height = 25
EOF

cat >> ~/.zshrc <<'EOF'
autoload -U promptinit; promptinit
prompt pure

source "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_FUZZY=true

HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

export PATH="$PATH:$(go env GOPATH)/bin"

alias ll="ls -lA"
alias cdgit="cd ~/git"
alias cdtmp="cd ~/tmp"

alias gogetall="go mod tidy && go get -u ./... && go mod vendor"
alias gofmt="gofumpt -w -l ."
EOF
