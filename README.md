# OSX Settings

This repository contains my bash, zsh, and Vim settings.

Some of the features include:

* Nicely colored prompt
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
    ~/.osx_settings/install

This will create backups for anything you already have and add symlinks to these parts.

## Updgrading

To get the latest and greatest:

    cd ~/.osx_settings
    git pull origin master
    ./update-submodules

This will update all the vim plugins (through pathogen) too. If you've customized anything, you will
have to deal with merge conflicts yourself.

## Customizing

This scripts adds aliases for your project directories, but you'll have to tell it where your
projects can be found.

If you're using bash, edit `.bashrc` and add something like:

    PROJECT_PARENT_DIRS[0]="$HOME/code"

If you're using zsh, edit `.zshrc` and add something like:

    PROJECT_PARENT_DIRS+=("$HOME/code")

Alternatively, you can add any configuration to `bash/00_personal.sh` or `zsh/00_personal.zsh`. This
way it will get automatically loaded, without creating merge conflicts when you update.

## Tips

Don't forget to enable 'Use bright colors for bold text' in Terminal.app, if you have trouble
reading stuff.

My ZSH config is still rather newish, just switched to it. If you're not already using zsh, you
should, it rocks!

### iTerm2

iTerm2 is totally awesome, but you cannot import and export your settings. So here are my more
interesting settings.

Global Settings:

* Show window number in title: off
* Show current job name in title: off

Advanced Settings:

* Hide scrollbar and resize control: on
* Hide tab when there is only one session: on

Bookmark Settings, Global:

* Command: /usr/local/bin/zsh
* Reuse Previous Tab's Directory

Basic Colors:

* Foreground:     `#EEEEEE`
* Background:     `#000000`
* Bold:           `#FFFFFF`
* Selection:      `#353883`
* Selected Text:  `#FFFFFF`
* Cursor:         `#FFA560`
* Cursor Text:    `#FFFFFF`

ANSI Colors: Normal:

* Black:    `#000000`
* Red:      `#FF6C60`
* Green:    `#A8FF60`
* Yellow:   `#FFFFB6`
* Blue:     `#96CBFE`
* Magenta:  `#FF73FD`
* Cyan:     `#C6C5FE`
* White:    `#EEEEEE`

ANSI Colors: Bright:

* Black:    `#555555`
* Red:      `#FF5555`
* Green:    `#CEFFAB`
* Yellow:   `#FFFFCB`
* Blue:     `#B5DCFE`
* Magenta:  `#FF9CFE`
* Cyan:     `#DFDFFE`
* White:    `#FFFFFF`

Bookmark Settings, Display:

* Anti-Aliasing
* Fonts: 12pt DejaVu Sans Mono

Bookmark Settings, Terminal:

* Keep bookmark name in session-set window title: off
* Close the session when it ends: on
* Silence bell
* Character Encoding: Unicode (UTF-8)
* Report Terminal Type: xterm
* Enable xterm mouse reporting: on


## Credits

I can't remember exactly where I got all stuff, but mostly from `relevance/etc`. And my zsh config
is heavily influenced from `bryanl/zshkit`. Heavily modified some stuff to fit my own needs of
course.

Thanks everybody who contributed! Feel free to use this, fork this or whatever. Additions are very
welcome!

For more information, see my website: [iain.nl](http://iain.nl/).
