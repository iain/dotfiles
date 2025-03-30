eval "$(/opt/homebrew/bin/brew shellenv)"

# https://asdf-vm.com/
fish_add_path -m "$HOME/.asdf/shims"

fish_add_path "$HOME/.dotfiles/bin"
fish_add_path "/Applications/MacVim.app/Contents/bin/"

# postgresql@16
if [ -f /opt/homebrew/opt/postgresql@16/bin/psql ]
  fish_add_path "/opt/homebrew/opt/postgresql@16/bin"
  set -gx LDFLAGS "-L/opt/homebrew/opt/postgresql@16/lib"
  set -gx CPPFLAGS "-I/opt/homebrew/opt/postgresql@16/include"
  set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/postgresql@16/lib/pkgconfig"
end

# https://starship.rs/
if which -s starship; starship init fish | source; end

# https://github.com/ajeetdsouza/zoxide
if which -s zoxide; zoxide init fish | source; end

# https://direnv.net/
if which -s direnv; direnv hook fish | source; end

# https://github.com/eth-p/bat-extras
if which -s batman; batman --export-env | source; end

# https://github.com/junegunn/fzf
if which -s fzf; fzf --fish | source; end

# https://github.com/eza-community/eza
if which -s eza
  alias ls="eza --group-directories-first"
  alias l="eza --long --group-directories-first --git --all --time-style=iso"
else
  alias l="ls -FhAlo"
end

if which -s rg
  alias grep="rg"
end

# git abbreviations
abbr -a a       "git add --all"
abbr -a aa      "git add --all"
abbr -a amend   "git commit --amend"
abbr -a c       "git commit"
abbr -a co      "git checkout"
abbr -a d       "git diff"
abbr -a dc      "git diff --cached"
abbr -a g       "git"
abbr -a g12     "git rev-parse HEAD | cut -c 1-12"
abbr -a gf      "git fetch --all"
abbr -a gl      "git log"
abbr -a glp     "git log -p"
abbr -a gpb     "git-publish-branch"
abbr -a gpr     "gh pr create --assignee @me --fill"
abbr -a gr      "git recent"
abbr -a p       "git push"
abbr -a re      "git restore"
abbr -a s       "git status -s"
abbr -a st      "git status"
abbr -a sw      "git switch"
abbr -a unstage "git restore --staged --"
abbr -a up      "git pull --ff-only"

# ruby abbreviations
abbr -a b   "bundle"
abbr -a be  "bundle exec"
abbr -a cu  "cucumber"
abbr -a r   "rails"
abbr -a wip "cucumber -p wip"
abbr -a of  "rspec --only-failures"
abbr -a rdm "rails db:migrate"
