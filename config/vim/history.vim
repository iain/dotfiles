let s:vim_state = g:xdg_state_home . '/vim'

" Vim doesn't create these itself, and fails to write swap, backup and undo
" files without them. Private, since they hold copies of edited files.
for s:dir in ['swap', 'backup', 'undo']
  call mkdir(s:vim_state . '/' . s:dir, 'p', 0700)
endfor

let &directory = s:vim_state . '/swap/'

" Backup:
let &backupdir = s:vim_state . '/backup/'
set backup

" Undo:
let &undodir = s:vim_state . '/undo/'
set undofile         " Persistent undo
set undolevels=1000  " Maximum number of changes that can be undone
set undoreload=10000 " Maximum number lines to save for undo on a buffer reload
