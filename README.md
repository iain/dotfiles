# OSX Settings

This repository contains my bash, zsh, and Vim settings.

Some of the features include:

* Nicely colored prompt for both Bash and ZSH.
* Automatic project aliases
* Ruby on Rails specific aliases
* RVM support
* Bundler compatible irbrc
* Vim configuration
* ... and much more!

## Installation

Installation is really easy, just run these commands:

    git clone git://github.com/iain/osx_settings.git ~/.osx_settings
    cd ~/.osx_settings
    ./install

This will create backups for anything you already have and add symlinks to these parts.

Dont't forget to configure git:

    git config --global user.name "Your Name"
    git config --global user.email you@example.com

## Upgrading

To get the latest and greatest:

    cd ~/.osx_settings
    git pull origin master
    ./update-submodules

This will update all the vim plugins (through pathogen) too. If you've customized anything, you will
have to deal with merge conflicts yourself.

## Customizing

### Project aliases

This scripts adds aliases for your project directories, but you'll have to tell it where your
projects can be found.

Depending on which shell you use, create `bash/98_project_dirs.sh` or `zsh/98_project_dirs.zsh`.

If you're using bash, edit `.bashrc` and add something like:

    PROJECT_PARENT_DIRS[0]="$HOME/code"

If you're using zsh, edit `.zshrc` and add something like:

    PROJECT_PARENT_DIRS+=("$HOME/code")

Add as many directories as you like.

### Fonts

I'm using Deja Vu Sans mono as font. You can download it [here](http://dejavu-fonts.org/wiki/Download).

Programmers can be very anal about fonts, so if you don't like it, feel free to use something
different.

### iTerm2

In the iTerm2 General settings, check `Load preferences from a user-defined folder or URL`. Fill in
the text field to point to `/Users/your_name/.osx_settings/iterm2`.
You might need to restart iTerm2 after that.

### Terminal.app

Don't forget to enable `Use bright colors for bold text` in Terminal.app, if you have trouble
reading the colors. And choose the Pro theme of course.

### Homebrew

Here's what I install on a clean OSX:

```
brew install ack imagemagick mongodb par readline wget git-flow libyaml mysql sl zsh cowsay node sqlite htop memcached postgresql tree elasticsearch cowsay
```

Make sure to read the caveats of those packages to make them start up automatically when that makes sense.

## Credits

Thanks everybody who puts their dotfiles online. I copied a lot from practically every repository.

Feel free to use this or fork this. Additions are very welcome!
