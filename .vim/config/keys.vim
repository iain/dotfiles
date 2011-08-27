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


" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" shifting with Cmd square brackets
nmap <D-[> <<
nmap <D-]> >>
vmap <D-[> <gv
vmap <D-]> >gv

" Move current line down/up
map <D-j> ]e
map <D-k> [e

" Move visually selected lines down/up
vmap <D-j> ]egv
vmap <D-k> [egv

" Visually select the text that was last edited/pasted
nmap gV `[v`]
