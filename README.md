# .dotfiles

> In Unix-like operating systems, any file or folder that starts with a dot character (for example, /home/user/.config), commonly called a dot file or dotfile, is to be treated as hidden.
> A convention arose of using dotfile in the user's home directory to store per-user configuration or informational text.

Here are the settings I use.

## Installation

These are the steps for installing the essentials.

1. Install [iTerm2](http://www.iterm2.com/)
2. Install [MacVIM](http://macvim-dev.github.io/macvim/)
3. Install [Homebrew](http://brew.sh/)
4. Install some of the most often used programs:

        brew install zsh git par the_silver_searcher tree

5. Install the dotfiles:

        git clone https://github.com/iain/dotfiles.git ~/.dotfiles
        cd ~/.dotfiles
        ./script/install

    (This will backup any previous dotfiles you have.)

6. Configure iTerm2:

    * Open iTerm2.
    * Go to the Preferences (`⌘,`)
    * In the General tab, check `Load preferences from a custom folder or URL`.
    * Fill in: `~/.dotfiles/iterm2`.
    * Restart iTerm2.

7. Configure Git to use your own name:

    Add and change these lines to `~/.dotfiles/config/personal.sh`:

        export GIT_AUTHOR_NAME="Your Name"
        export GIT_AUTHOR_EMAIL="yourname@yourdomain.com"
        export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
        export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL


## Config


| Directory | Description                |
| --------- | -------------------------- |
| bin       | executables                |
| config    | zsh and bash configuration |
| iterm2    | iterm2 configuration       |
| rc        | all the dotfiles           |
| script    | private helper scripts     |


### Vim

Vim will automatically install itself when you start Vim for the first time.

Delete (or move) your `~/.vim` directory to let it install.

### Personal Configuration

You can put configuration options that are personal, like custom paths, and
other environment variables in one of these files:

* `config/personal.sh` (will be loaded in both Bash and ZSH)
* `config/personal.zsh` (ZSH specific configuration)
* `config/personal.bash` (Bash specific configuration)

### Project aliases

This scripts adds aliases for your project directories, but you'll have to tell
it where your projects can be found. There are however differences in ZSH and
Bash syntax. Use the personal configuration files as mentioned above to set
them.

For ZSH:

    PROJECT_PARENT_DIRS+=("$HOME/Work")
    PROJECT_PARENT_DIRS+=("$HOME/Personal")

For Bash:

    PROJECT_PARENT_DIRS[0]="$HOME/Work"
    PROJECT_PARENT_DIRS[0]="$HOME/Personal"

Add as many directories as you like.

### Fonts

I'm using the [Hack font](http://sourcefoundry.org/hack/). If this one is not to
your liking, [here are a bunch more](https://github.com/powerline/fonts).

### Aliases

There are a lot of aliases in my dotfiles.
Here are the ones I use on a daily basis:


| Alias     | Command                                            | Description                                       |
| --------- | -------------------------------------------------- | ------------------------------------------------- |
| `l`       | `ls -FhAlo`                                        | List only things that are not the same everywhere |
| `st`      | `git status`                                       |                                                   |
| `aa`      | `git add --all && git status -sb`                  | Add all files and show them                       |
| `c`       | `git commit`                                       |                                                   |
| `p`       | `git push`                                         |                                                   |
| `gf`      | `git fetch --all && git status`                    | Get everything locally, safe to run whenever      |
| `up`      | `git pull --ff-only`                               | git pull only if it's ~straight~ fast forward     |
| `upstash` | `git stash && git pull --ff-only && git stash pop` | yeah....                                          |
| `unstage` | `git reset HEAD --`                                | filenames autocomplete after this                 |
| `co`      | `git checkout`                                     |                                                   |
| `d`       | `git diff`                                         | what changes are unstaged?                        |
| `dc`      | `git diff --cached`                                | what changes are staged for commit?               |
| `m`       | `macvim --remote-silent`                           | opens a file in existing macvim window            |
| `b`       | `bundle install`                                   | with some extra smart to improve speed            |
| `be`      | `bundle exec`                                      | be rake, or be something else                     |
| `rdm`     | `rake db:migrate db:test:prepare`                  | get your database in check                        |
| `la`      | ...                                                | shows a pretty graph of your git commits          |
| `amend`   | `git commit --amend`                               | Edit the last commit                              |
| `psg`     | `ps aux grep`                                      | But without grep itself and with highlighting     |

Have a look at `rc/gitconfig` and `config/global.sh` for more commands.

## Credits

Thanks everybody who puts their dotfiles online. I copied a lot from
practically every repository.

Feel free to use this or fork this. Additions are very welcome!
