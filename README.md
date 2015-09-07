# .dotfiles

Here are the settings I use.

* Ruby
* ZSH
* Vim

## Installation

These are the steps for installing a clean machine:

1. Install [iTerm2](http://www.iterm2.com/)
2. Install [Homebrew](http://mxcl.github.io/homebrew/):

        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

3. Install some of the most often used programs:

        brew install zsh git macvim par wget libyaml the_silver_searcher tree

4. Install a recent Ruby version:

        brew install rbenv ruby-build
        rbenv install 2.2.3
        rbenv global 2.2.3

5. Install the dotfiles:

        git clone https://github.com/iain/dotfiles.git ~/.dotfiles
        cd ~/.dotfiles
        ./script/install

    This will backup any previous dotfiles you have.

6. Configure iTerm2:

    * Open iTerm2.
    * Go to the Preferences (⌘,)
    * In the General tab, check `Load preferences from a custom folder or URL`.
    * Fill in the text field to point to `/Users/your_name/.dotfiles/iterm2`.
      (replace "your_name" with your username, which you can verify by running `whoami`)
    * Restart iTerm2.

7. Configure Git to use your own name:

    Add and change these lines to `~/.dotfiles/config/personal.sh`:

        export GIT_AUTHOR_NAME="Your Name"
        export GIT_AUTHOR_EMAIL="yourname@yourdomain.com"
        export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
        export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL

8. Celebrate!

## Config

Here are some more things you can do.

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

I'm using DejaVuSansMono as font. You can download it [here](http://dejavu-fonts.org/wiki/Download).

Programmers can be very anal about fonts, so if you don't like it, feel free to use something
different.

My DejaVuSansMono, including the [powerline](https://github.com/Lokaltog/vim-powerline)
patch is included for convenience.

### More programs.

For my own convenience, here are some extra apps I tend to want on my machine.

    brew install mysql postgresql sqlite \
      mercurial go elixir node \
      imagemagick graphviz \
      cloc htop-osx

**NB** Don't forget to read the output and follow the instructions.

Some Ruby related stuff:

    curl get.pow.cx | sh
    gem install bundler pry pry-doc powder


## Credits

Thanks everybody who puts their dotfiles online. I copied a lot from
practically every repository.

Feel free to use this or fork this. Additions are very welcome!
