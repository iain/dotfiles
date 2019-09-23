# .dotfiles

> In Unix-like operating systems, any file or folder that starts with a dot character (for example, /home/user/.config), commonly called a dot file or dotfile, is to be treated as hidden.
> A convention arose of using dotfile in the user's home directory to store per-user configuration or informational text.

Here are the settings I use. There are installation scripts for most things, so getting them should be easy.

## Installation

These are the steps for installing the essentials.

1. Install [iTerm2](http://www.iterm2.com/)
2. Install [MacVIM](http://macvim-dev.github.io/macvim/)
3. Install [Homebrew](http://brew.sh/)
4. Install the dotfiles and homebrew apps.

        git clone https://github.com/iain/dotfiles.git ~/.dotfiles
        cd ~/.dotfiles
        ./script/install

    This will backup any previous dotfiles you have.
    Also, check `Brewfile` to see which packages are going to be installed.


5. Configure iTerm2:

    * Open iTerm2.
    * Go to the Preferences (`⌘,`)
    * In the General tab, check `Load preferences from a custom folder or URL`.
    * Fill in: `~/.dotfiles/iterm2`.
    * Restart iTerm2.

6. Configure Git to use your own name:

    Add these `~/.dotfiles/config/personal.sh` and update them to your liking.

        export GIT_AUTHOR_NAME="Your Name"
        export GIT_AUTHOR_EMAIL="yourname@yourdomain.com"


## Config

| Directory | Description                |
| --------- | -------------------------- |
| bin       | executables                |
| config    | zsh and bash configuration |
| iterm2    | iterm2 configuration       |
| rc        | all the dotfiles           |
| script    | private helper scripts     |


`~/.dotfiles/config/personal.sh` is where I add aliases that don't make sense
for the rest of the world, and where I modify $PATH, depending on what I
install.

### Vim

Vim will automatically install itself when you start Vim for the first time.

Delete (or move) your `~/.vim` directory to let it install.

To get new versions of your plugins after the first install:

```
:PlugUpgrade
:PlugUpdate
:PlugClean
```

### Fonts

Get a couple of really good Terminal fonts with powerline support baked in:

```
git clone https://github.com/powerline/fonts.git ~/fonts
cd ~/fonts
./install.sh
cd
rm -r ~/fonts
```

My personal preference is "Hack".

### Aliases

There are a lot of aliases in my dotfiles.
Here are the ones I use on a daily basis:

| Alias     | Command                             | Description                                       |
| --------- | ----------------------------------- | ------------------------------------------------- |
| `l`       | `ls -FhAlo`                         | List only things that are not the same everywhere |
| `st`      | `git status`                        |                                                   |
| `aa`      | `git add --all && git status -sb`   | Add all files and show them                       |
| `c`       | `git commit`                        |                                                   |
| `p`       | `git push`                          |                                                   |
| `gf`      | `git fetch --all && git status`     | Get everything locally, safe to run whenever      |
| `up`      | `git pull --ff-only`                | git pull only if it's ~straight~ fast forward     |
| `upstash` | `git stash && up && git stash pop`  | yeah....                                          |
| `unstage` | `git reset HEAD --`                 | filenames autocomplete after this                 |
| `co`      | `git checkout`                      |                                                   |
| `d`       | `git diff`                          | what changes are unstaged?                        |
| `dc`      | `git diff --cached`                 | what changes are staged for commit?               |
| `m`       | `macvim --remote-silent`            | opens a file in existing macvim window            |
| `b`       | function...                         | smart bundle install and bundle exec (optionally) |
| `r`       | `rails`                             | Uses Spring or Bundler if available               |
| `rdm`     | `rake db:migrate db:test:prepare`   | get your database in check                        |
| `la`      | function...                         | shows a pretty graph of your git commits          |
| `ll`      | function...                         | shows a pretty graph of this branch only          |
| `amend`   | `git commit --amend`                | Edit the last commit                              |
| `psg`     | `ps aux | grep`                     | But without grep itself and with highlighting     |

Have a look at `rc/gitconfig` and `config/global.sh` for more commands.

### Ruby

These days I use whatever Ruby version is specified by Homebrew. I don't bother
with having multiple versions of Ruby anymore. If a project requires a specific
Ruby version I use Docker.

Installing Ruby via Homebrew is as simple as

```
$ brew install ruby
```

Common Ruby commands are wrapped in a function to be smart enough to use Spring
or Bundler when possible. This means you can just type `rspec` and it will use
`spring rspec` if that is available.

## Git commit signing

To get git commit signing and verified commits in Github:

1. Download and install GPG Suite from https://gpgtools.org/
2. When launching you'll be asked to generate a new key pair. Do that.
4. You'll be asked to upload the key. Optional, I think, but I did it.
5. Right-Click on your newly generated key, choose "Copy". Your public key is now in your clipboard.
5. On github, go to your settings: https://github.com/settings/gpg/new
6. Click button "New GPG key"
7. Paste your public key, you copied it in step 4.
8. On the overview of your GPG keys on github, you'll see your "Key ID". Copy that.
9. Add the Key ID to your Git settings:  e.g. $ git config --global user.signingkey 3AA5C34371567BD2
10. Tell git to sign all future commits: $ git config --global commit.gpgsign true
11. Upon the next commit that you make, GPG suite will ask you for the password you entered in step 2.

## Credits

Thanks everybody who puts their dotfiles online. I copied a bunch from practically every repository.

Feel free to use this or fork this. Additions are very welcome!
