" Common Command Typos
command! Q  quit    " converts ... :Q  => :q
command! W  write   " converts ... :W  => :w
command! Wq wq      " converts ... :Wq => :wq
command! Wn wn      " converts ... :Wn => :wn
command! WN wN      " converts ... :WN => :wN

" A common typo is ":E" when actually meaning ":e" and not ":Explore" or ":Errors".
cnoreabbrev E e

" in insert mode, jj or jk goes to normal mode
" if you ever need to type jj for real, type it slowly, like on old school mobile phones
inoremap jj <ESC>
" inoremap jk <ESC>
map <C-C> <ESC>

" Move to the start of line
nnoremap H ^
" Move to the end of line
nnoremap L $

" Map <Esc> to exit terminal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l


" Restore return to default for quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

" Open notes file
map <Leader>q :split ~/Documents/notes.md<cr>
map <Leader>w :!touch tmp/restart.txt<cr>
