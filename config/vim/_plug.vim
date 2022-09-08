" Install vim-plugged in needed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Plug 'tpope/vim-bundler'               " ruby bundler support
Plug 'AndrewRadev/splitjoin.vim'
Plug 'ayu-theme/ayu-vim'               " colorscheme
Plug 'bogado/file-line'                " open file.ext:123 directly
Plug 'csexton/trailertrash.vim'
Plug 'dense-analysis/ale'              " linting
Plug 'fatih/vim-go'
Plug 'janko-m/vim-test'                " Runs tests
Plug 'jlanzarotta/bufexplorer'
Plug 'jremmen/vim-ripgrep'             " Faster Grep
Plug 'junegunn/vim-easy-align'         " align code
Plug 'kien/ctrlp.vim'
Plug 'luochen1990/rainbow'
Plug 'michaeljsmith/vim-indent-object' " Treat indentation as text object
Plug 'segeljakt/vim-silicon'
Plug 'sheerun/vim-polyglot'            " Syntax highlighting for all
Plug 'thiagoalessio/rainbow_levels.vim'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'            " auto commenting
Plug 'tpope/vim-cucumber'              " cucumber support
Plug 'tpope/vim-eunuch'                " unix commands
Plug 'tpope/vim-fugitive'              " Git integration
Plug 'tpope/vim-projectionist'         " map related/alternate files
Plug 'tpope/vim-rails'                 " Ruby on Rails integration
Plug 'tpope/vim-rake'                  " Ruby integration
Plug 'tpope/vim-repeat'                " repeat more things
Plug 'tpope/vim-rhubarb'               " Github integration
Plug 'tpope/vim-sensible'              " common defaults
Plug 'tpope/vim-surround'              " modify surroundings, like quotes, brackets
Plug 'tpope/vim-unimpaired'            " toggling options
Plug 'tpope/vim-vinegar'               " improving interaction with NetRW
Plug 'vim-ruby/vim-ruby'

Plug 'robertmeta/nofrils'
Plug 'ulwlu/elly.vim'
Plug 'fcpg/vim-farout'
Plug 'danishprakash/vim-yami'
Plug 'kamykn/dark-theme.vim'
" Plug 'haystackandroid/shoji'
Plug 'wsniper/vim-color-theme-protect-eyes'

call plug#end()
