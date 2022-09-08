if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

map <leader>i :call MyInstall()<cr>
function! MyInstall()
  :w
  :source ~/.config/nvim/_plug.vim
  :PlugInstall
endfunction

call plug#begin('~/.vim/plugged')

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

" Plug 'neoclide/coc.nvim', {'branch': 'release'} " autocomplete tools

" telescope and dependencies
" Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim'
" Plug 'kyazdani42/nvim-web-devicons'
" Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }


call plug#end()
