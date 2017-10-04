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

### Fonts

Get a couple of really good Terminal fonts with powerline support baked in:

```
git clone https://github.com/powerline/fonts.git ~/fonts
cd ~/fonts
./install
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

For installing Ruby, I prefer `ruby-install` and `chruby`.

```
$ brew install chruby ruby-install
$ ruby-install ruby 2.4.2
```

Then don't forget to add the version to `~/.dotfiles/config/personal.sh`

``` shell
chruby 2.4.2
```

Both bash and zsh are configured to detect chruby, rbenv or rvm. Specifying
which version to use is left up to you.

Common Ruby commands are wrapped in a function to be smart enough to use Spring
or Bundler when possible. This means you can just type `rspec` and it will use
`spring rspec` if that is available.

## Credits

Thanks everybody who puts their dotfiles online. I copied a bunch from practically every repository.

Feel free to use this or fork this. Additions are very welcome!
