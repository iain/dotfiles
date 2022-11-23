# .dotfiles

> In Unix-like operating systems, any file or folder that starts with a dot character (for example, /home/user/.config), commonly called a dot file or dotfile, is to be treated as hidden.
> A convention arose of using dotfile in the user's home directory to store per-user configuration or informational text.

Here are the settings I use. There are installation scripts for most things, so
getting them should be easy.

Feel free to adopt anything you like from these settings. However, I recommend
you make your own, and only add things you understand and like, so you build
your own toolchain.

## Project Structure

| Directory | Description                |
| --------- | -------------------------- |
| bin       | executables                |
| config    | zsh and fish configuration |
| iterm2    | iterm2 configuration       |
| rc        | all the dotfiles           |
| script    | private helper scripts     |


I put all personal and private configuration in `config/personal.sh`, which is
ignored by git, so it doesn't accidentally end up on the internet.

## Installation

### Pre-requisites

Download and install the following applications manually:

* [iTerm2](http://www.iterm2.com/)
* [MacVIM](http://macvim-dev.github.io/macvim/)
* [Homebrew](http://brew.sh/)

### Code

To install dotfiles:

```zsh
git clone https://github.com/iain/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./script/install
```

This will backup any previous dotfiles you have.

### Homebrew

To install all the neat little homebrew tools listed in `Brewfile`:

```zsh
brew tap Homebrew/bundle
brew bundle
```

### iTerm

To configure iTerm:

1. Open iTerm2.
2. Go to the Preferences (`⌘,`)
3. In the General tab, check `Load preferences from a custom folder or URL`.
4. Fill in: `~/.dotfiles/iterm2`.
5. Restart iTerm2.

### asdf

I use [asdf](https://asdf-vm.com/) these days to install programming languages.

Here is how to install ruby (replace `latest` with an older version if you like):

```zsh
asdf plugin add ruby
asdf install ruby latest
asdf global ruby latest
```

Python and most other languages work the same, except [NodeJS](https://github.com/asdf-vm/asdf-nodejs).

To update all plugins, when new versions come out:

```zsh
asdf plugin update --all
```

### Fonts

Should be installed via Homebrew.

## Documentation

Below is extra documentation on what's configured in the dotfiles. Or at least,
some of the highlights.

### Vim

Configured to be in `~/.config/vim/` to mirror nvim's config.

### Aliases && Commands

There are a lot of aliases and commands in my dotfiles.

Configuration in `~/.dotfiles/config/general.sh` and bin files in `~/.dotfiles/bin`.

| Command       | Description                          |
| -------       | ------------------------------------ |
| `flushdns`    | flush DNS cache (macOS only)         |
| `imgcat`      | show image in terminal (iTerm only)  |
| `l`           | alias of `ls -FhAlo`                 |
| `m`           | opens file in existing macvim window |
| `psg`         | find running process quickly         |
| `ssh-copy-id` | copy your SSH key to remote server   |
| `tf`          | alias of `tail -f -n 200`            |

Other:

* `ls` is replaced by GNU version if gnu tools are installed on macOS.
* Replaced `grep` with `rg`
* `aws-docker-login` for logging docker into AWS ECR.
* `docker-stop-all` stops all running docker containers
* `docker-implode` deletes all docker image caches, run from time to time to get lots of disk space back

### Git

Configuration for git is found in `~/.gitconfig` and `~/.dotfiles/config/git.sh`

Here are some of the highlights:

| Command   | Description                                            |
| --------- | -----------------------------------                    |
| `aa`      | short for `git add --all && git status -s`             |
| `amend`   | short for `git commit --amend`                         |
| `c`       | short for `git commit`                                 |
| `current` | show the SHA of the current commit                     |
| `d`       | short for `git diff`                                   |
| `dc`      | short for `git diff --cached`                          |
| `g12`     | First 12 chars of current git commit                   |
| `gf`      | short for `git fetch --all && git status`              |
| `gpb`     | Publish your branch without having to type branch name |
| `gpr`     | Quickly make a draft PR in GitHub                      |
| `p`       | short for `git push`                                   |
| `re`      | short for `git restore`                                |
| `s`       | short for `git status -s`                              |
| `st`      | short for `git status`                                 |
| `sw`      | short for `git switch`                                 |
| `unstage` | short for `git restore --cached --`                    |
| `up`      | short for `git pull --ff-only`                         |
| `upstash` | short for `git stash && up && git stash pop`           |

Other:

* Local changes will be rebased
* I regularly perform `git-cleanup`, which wraps the following tasks:
    * `git fetch --all --prune` - removes information about old remote branches
    * `git-delete-merged-branches` - removes branches that have been merged in
    * `git-delete-squashed-branches` - removes branches that have been squashed in GitHub
    * `git prune` - remove dangling objects
    * `git gc --aggressive --auto` - clean up files and optimize repository
* Only run the cleanup scripts from a clean default branch!
* All commands should be compatible with whatever default branch you have (see `git-default-branch`)
* Default branch for new repos is `main` instead of `master`.
* Read the `~/.gitconfig` file for more neat aliases.

### Ruby

The configuration for ruby is found in `~/.dotfiles/config/ruby.sh`

Here are some of the aliases:

| Command   | Description                                  |
| --------- | -----------------------------------          |
| `b`       | short for `bundle install`                   |
| `be`      | short for `bundle exec`                      |
| `psr`     | finds ruby processes                         |
| `r`       | short for `rails`                            |
| `rdm`     | will run migrations for development and test |
| `wip`     | short for `cucumber --profile wip`           |

Other:

* Rails, Rake, Cucumber, RSpec will use Spring automatically if it's available and binstubbed.
* `rspec_focus` and `cucumber_focus` are for running a subset of tests and are setup to be used together with vim-test

## Credits

Thanks everybody who puts their dotfiles online. I copied a bunch from practically every repository.

Feel free to use this or fork this. Additions are very welcome!
