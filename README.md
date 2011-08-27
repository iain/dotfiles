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

<strong>Caution</strong> Don't forget to change the `.gitconfig` file.

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

Don't forget to enable `Use bright colors for bold text` in Terminal.app, if you have trouble
reading stuff.

My ZSH config is still rather newish, just switched to it. If you're not already using zsh, you
should, it rocks! If you find anything missing, please open a pull request!

### iTerm2

iTerm2 is totally awesome, but you cannot import and export your settings. So here are my more
interesting settings.

In the iTerm2 General settings, check `Load preferences from a user-defined folder or URL`. Fill in
the text field to point to `~/.osx_settings/iterm2`. You might need to restart iTerm2 after that.

You now have iTerm2 set up with zsh. To get prettier colors, go to the `Profiles` tab and select
`Colors` in the right pane. Open the `Load Presets` dropdown and choose `Import`. The colorschemes are
in the iterm2 directory. You can use `Cmd+Shift+G` to access the otherwise hidden `.osx_settings`
directory. Choose `ir_black.itermcolors` to color the terminal in the same colors as vim.

## Credits

I can't remember exactly where I got all stuff, but mostly from `relevance/etc`. And my zsh config
is heavily influenced from `bryanl/zshkit`. Heavily modified some stuff to fit my own needs of
course.

Thanks everybody who contributed! Feel free to use this, fork this or whatever. Additions are very
welcome!

For more information, see my website: [iain.nl](http://iain.nl/).
