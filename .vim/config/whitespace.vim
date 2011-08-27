" Remove ANY trailing whitespaces in ANY file I save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    %s/\t/  /ge
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" nicer looking tabs and whitespace
if (&termencoding == "utf-8") || has("gui_running")
  set listchars=tab:·\ ,trail:\ ,
  set list
  noremap <Leader>i :set list!<CR>
endif
