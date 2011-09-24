set nocompatible

" Load the plugins!
call pathogen#runtime_append_all_bundles()
" call pathogen#helptags()

" Encoding
set encoding=utf-8

" If you see <leader>x than it means to press comma-x
let mapleader=","

" more config per topic
source ~/.vim/config/arrows.vim
source ~/.vim/config/buf_explorer.vim
source ~/.vim/config/command-t.vim
source ~/.vim/config/history.vim
source ~/.vim/config/keys.vim
source ~/.vim/config/search.vim
source ~/.vim/config/splits.vim
source ~/.vim/config/statusbar.vim
source ~/.vim/config/indent.vim
source ~/.vim/config/tabularize.vim
source ~/.vim/config/tests.vim
source ~/.vim/config/visual.vim
source ~/.vim/config/whitespace.vim
source ~/.vim/config/winheight.vim
