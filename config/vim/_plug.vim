" Install vim-plugged if needed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Defaults
Plug 'tpope/vim-sensible'              " universal set of vim defaults

" Colorscheme
Plug 'iain/spectral'                   " custom colorscheme

" Editing
Plug 'AndrewRadev/splitjoin.vim'       " switch between single-line and multi-line statements
Plug 'godlygeek/tabular'               " align text by pattern
Plug 'michaeljsmith/vim-indent-object' " treat indentation levels as text objects
Plug 'tpope/vim-commentary'            " toggle comments with gc
Plug 'tpope/vim-repeat'               " make . work with plugin mappings
Plug 'tpope/vim-surround'             " add/change/delete surrounding quotes, brackets, tags
Plug 'tpope/vim-unimpaired'           " paired bracket mappings for toggling and navigation

" Navigation
Plug 'bogado/file-line'                " open file:line (e.g. vim file.rb:42)
Plug 'jlanzarotta/bufexplorer'        " browse and switch between open buffers
Plug 'junegunn/fzf'                   " fuzzy finder binary
Plug 'junegunn/fzf.vim'               " fuzzy finder vim integration
Plug 'tpope/vim-projectionist'        " define alternate/related file mappings
Plug 'tpope/vim-vinegar'              " enhance netrw file browser with -

" Search
Plug 'jremmen/vim-ripgrep'            " ripgrep integration for project-wide search

" Git
Plug 'tpope/vim-fugitive'             " git commands from within vim
Plug 'tpope/vim-rhubarb'              " GitHub integration for fugitive (:GBrowse)

" Linting and Fixing
Plug 'dense-analysis/ale'             " asynchronous linting and fixing

" Testing
Plug 'janko-m/vim-test'               " run tests from within vim

" Ruby and Rails
Plug 'jlcrochet/vim-rbs'              " syntax highlighting for Ruby type signatures
Plug 'slim-template/vim-slim'         " syntax highlighting for Slim templates
Plug 'tpope/vim-cucumber'             " syntax and navigation for Cucumber features
Plug 'tpope/vim-rails'                " Rails navigation, commands, and generators
Plug 'tpope/vim-rake'                 " Rake navigation and commands for Ruby projects
Plug 'vim-ruby/vim-ruby'              " enhanced Ruby syntax, indentation, and compilation

" Language Support
Plug 'sheerun/vim-polyglot'           " syntax and indentation for 100+ languages
Plug 'tpope/vim-apathy'               " set path for include-based navigation per filetype

" Utilities
Plug 'csexton/trailertrash.vim'       " highlight and remove trailing whitespace
Plug 'segeljakt/vim-silicon'          " generate code screenshots via Silicon
Plug 'tpope/vim-eunuch'               " unix commands (:Rename, :Delete, :Mkdir, :SudoWrite)

call plug#end()
