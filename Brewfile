#!/usr/bin/env ruby
# frozen_string_literal: true

# main
brew "antigen"
brew "asdf"
brew "git"
brew "luajit", args: ["HEAD"]
brew "neovim", args: ["HEAD"]
brew "gnupg"
brew "rubyfmt"
brew "perl"

# hack font with icons
tap "homebrew/cask-fonts"
cask "font-hack-nerd-font"

# tools
brew "awscli"
brew "bat"
brew "cloc"
brew "coreutils"
brew "fd"
brew "fzf"
brew "gh"
brew "gpg"
brew "gping"
brew "graphviz"
brew "jq"
brew "libmaxminddb"
brew "nmap"
brew "par"
brew "pre-commit"
brew "readline"
brew "ripgrep"
brew "siege"
brew "tree"
brew "watch"
brew "wget"

# fun
brew "cowsay"
brew "gti"
brew "sl"

# databases
brew "memcached",      restart_service: :changed
brew "postgresql",     restart_service: :changed
brew "redis",          restart_service: :changed
brew "sqlite"

tap "elastic/tap"
brew "elastic/tap/elasticsearch-oss",  restart_service: :changed
