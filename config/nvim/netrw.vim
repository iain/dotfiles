let g:netrw_cursor=0

" force Ctrl-L to work like splits again

augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
    noremap <buffer> <C-l> <c-w>l
endfunction
