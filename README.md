# OSX Settings

This repository contains my bash, zsh, and Vim settings.

Some of the features include:

* Nicely colored prompt for both Bash and ZSH.
* Yellow = clean, red = dirty in prompt for SVN and Git
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

## Updgrading

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

## Tips

Don't forget to enable `Use bright colors for bold text` in Terminal.app, if you have trouble
reading stuff.

My ZSH config is still rather newish, just switched to it. If you're not already using zsh, you
should, it rocks! If you find anything missing, please open a pull request!

### iTerm2

iTerm2 is totally awesome, but you cannot import and export your settings. So here are my more
interesting settings.

In the iTerm2 General settings, check `Load preferences from a user-defined folder or URL`. Fill in
the text field to point to `/Users/your_name/.osx_settings/iterm2`.
You might need to restart iTerm2 after that.

## Credits

I can't remember exactly where I got all stuff, but mostly from `relevance/etc`. And my zsh config
is heavily influenced from `bryanl/zshkit`. Heavily modified some stuff to fit my own needs of
course.

Thanks everybody who contributed! Feel free to use this, fork this or whatever. Additions are very
welcome!

For more information, see my website: [iain.nl](http://iain.nl/).
