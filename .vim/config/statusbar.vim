" Always show statusbar
set laststatus=2

:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" " Set the status line
" set statusline=%#warningmsg#
" set statusline+=%*
" set statusline+=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%c\ Buf:%n\ [%b][0x%B]
" set statusline+=%{fugitive#statusline()}
