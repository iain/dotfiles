" Keep some stuff in the history
set history=100

" Backup and swap files
set backup
set backupdir=~/.vim/tmp/
set directory=~/.vim/tmp/

if version >= 730

  " undoing even after closing the file
  set undofile
  set undodir=~/.vim/undo

end

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
