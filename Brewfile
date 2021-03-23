#!/usr/bin/env ruby
# frozen_string_literal: true

# main
brew "antigen"
brew "fish"
brew "asdf"
brew "git"
brew "luajit", args: ["HEAD"]
brew "neovim", args: ["HEAD"]
brew "macvim"
brew "gnupg"
brew "rubyfmt"
brew "perl"

# hack font with icons
tap "homebrew/cask-fonts"
cask "font-hack-nerd-font"
cask "font-fira-code-nerd-font"
cask "font-ubuntu-nerd-font"
cask "font-ubuntu-mono-nerd-font"
cask "font-3270-nerd-font"

# tools
brew "awscli"
brew "bandwhich"
brew "bat"
brew "coreutils"
brew "ctags"
brew "dust"
brew "exa"
brew "fd"
brew "fzf"
brew "gh"
brew "gpg"
brew "gping"
brew "graphviz"
brew "grex"
brew "hyperfine"
brew "jq"
brew "libmaxminddb"
brew "nmap"
brew "par"
brew "pre-commit"
brew "procs"
brew "readline"
brew "ripgrep"
brew "sd"
brew "siege"
brew "starship"
# brew "tealdear"
brew "tokei"
brew "tree"
brew "watch"
brew "wget"
# brew "ytop"
brew "zoxide"

# fun
brew "cowsay"
brew "gti"
brew "sl"

# databases
brew "memcached",  restart_service: :changed
brew "postgresql", restart_service: :changed
brew "redis",      restart_service: :changed
brew "sqlite"

tap "elastic/tap"
brew "elastic/tap/elasticsearch-full", restart_service: :changed
