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
