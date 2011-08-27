" Backspace normally
set backspace=indent,eol,start

" If you see <leader>x than it means to press comma-x
let mapleader=","

" Rename :W to :w
command! W :w

" Turn off F1
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" in insert mode, jj goes to normal mode
" if you ever need to type jj for real, type it slowly, like on old school mobile phones
inoremap jj <ESC>
