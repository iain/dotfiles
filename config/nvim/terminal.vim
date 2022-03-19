" use Esc to go to normal more in terminal
tnoremap <Esc> <C-\><C-n>
" Use Ctrl+V escape to send escape to terminal
tnoremap <C-v><Esc> <Esc>

" Terminal mode:
tnoremap <C-h> <c-\><c-n><c-w>h
tnoremap <C-j> <c-\><c-n><c-w>j
tnoremap <C-k> <c-\><c-n><c-w>k
tnoremap <C-l> <c-\><c-n><c-w>l

" Open shell in vim
if has('nvim') || has('terminal')
  map <silent> <Leader>' :terminal<CR>
else
  map <silent> <Leader>' :shell<CR>
endif
