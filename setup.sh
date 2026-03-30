#!/usr/bin/env bash
set -e

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install --cask google-chrome ghostty slack jetbrains-toolbox visual-studio-code antigravity dockdoor
brew install go pure zsh-history-substring-search uv

touch ~/.hushlogin
mkdir -p ~/.config/ghostty

cat > ~/.config/ghostty/config <<'EOF'
theme = Snazzy
window-width = 120
window-height = 25
EOF

cat >> ~/.zshrc <<'EOF'
autoload -U promptinit; promptinit
prompt pure

alias ll="ls -lA"
alias cdgit="cd ~/git"
alias cdtmp="cd ~/tmp"

export PATH="$PATH:$(go env GOPATH)/bin"

alias gogetall="go mod tidy && go get -u ./... && go mod vendor"
alias gofmt="gofumpt -w -l ."

source "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_FUZZY=true
EOF