# Dotfiles

This repository contains my bash, zsh, and Vim settings.

Some of the features include:

* Nicely colored prompt for both Bash and ZSH.
* Automatic project aliases
* Ruby on Rails specific aliases
* RVM support
* Bundler compatible irbrc
* Vim configuration
* ... and much more!

There is absolutely NO guarantee for this project to work on your machine.
Only use this if you know what you are doing.

## Installation

Installation is really easy, just run these commands:

    git clone git://github.com/iain/osx_settings.git ~/.osx_settings
    cd ~/.osx_settings
    ./install

This will create backups for anything you already have and add symlinks to these parts.

Dont't forget to configure git:

    git config --global user.name "Your Name"
    git config --global user.email you@example.com

Vim will automatically install itself when you start it for the first time.
Delete (or move) your .vim home directory to let it install.

## Customizing

### Project aliases

This scripts adds aliases for your project directories, but you'll have to tell it where your
projects can be found.

For ZSH, edit `zsh/98_personal.zsh`, and add lines like:

    PROJECT_PARENT_DIRS+=("$HOME/code")

In Bash, edit `bash/98_personal.sh`, and add something like:

    PROJECT_PARENT_DIRS[0]="$HOME/code"

Add as many directories as you like.

### Fonts

I'm using Deja Vu Sans mono as font. You can download it [here](http://dejavu-fonts.org/wiki/Download).

Programmers can be very anal about fonts, so if you don't like it, feel free to use something
different.

My DejaVuSansMono, including the powerline patch is included for convenience.

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
brew install ack imagemagick par readline wget git-flow \
    libyaml mysql zsh node sqlite memcached postgresql tree
```

Make sure to read the caveats of those packages to make them start up automatically when that makes sense.

### Gems

I use [hitch](https://github.com/therubymug/hitch) for pair programming. I also use RVM.
After installing the rubies I want, I run.

``` bash
for x in $(rvm list strings); do rvm use $x@global && gem install hitch; done
```


## Credits

Thanks everybody who puts their dotfiles online. I copied a lot from practically every repository.

Feel free to use this or fork this. Additions are very welcome!
