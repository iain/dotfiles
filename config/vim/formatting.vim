set nowrap

set shiftround " round shifts to a multiple of shiftwidth
set expandtab  " Tabs are spaces, not tabs

set nojoinspaces      " prevent inserting two spaces after punctuation
set formatoptions+=1  " Do not wrap after a one-letter word
set formatoptions+=j  " Remove extra comment when joining lines

" par is a utility that is really good at wrapping lines
if executable('par')
  set formatprg=par\ -w110\ -q
endif

" Go up and down display lines in soft line breaks
nmap j gj
nmap k gk
vmap j gj
vmap k gk

" Visual shifting (does not exit Visual mode)
" vnoremap < <gv
" vnoremap > >gv

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EasyAlign:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Align = signs
nmap <Leader>a= vii<cr>:EasyAlign =<cr>gv
vmap <Leader>a= :EasyAlign =<cr>gv

" Align hashrockets
nmap <Leader>a> vii<cr>:EasyAlign =><cr>gv
vmap <Leader>a> :EasyAlign =><cr>gv

" Align commas
nmap <Leader>a, vii<cr>:EasyAlign ,<cr>gv
vmap <Leader>a, :EasyAlign ,<cr>gv

" Align words and fix indentation
nmap <Leader>aw vii<cr>:EasyAlign *\ <cr>=ip
vmap <Leader>aw :EasyAlign *\ <cr>gv=gv

" Align comments
nmap <Leader>ac vii<cr>:EasyAlign #<cr>gv

" Align blocks
nmap <Leader>a{ vii<cr>:EasyAlign {<cr>gv
vmap <Leader>a{ :EasyAlign {<cr>gv
vmap <Leader>a{ :EasyAlign {<cr>gv

" Align :
nmap <Leader>a: vii<cr>:EasyAlign :<cr>gv
vmap <Leader>a: :EasyAlign :<cr>gv

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabular:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Aligns tables in cucumber, from tim pope: https://gist.github.com/tpope/287147
function! s:AlignCucumberTables()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" Only enable in cucumber
function! EnableCucumberTables()
  inoremap <silent> <Bar>   <Bar><Esc>:call <SID>AlignCucumberTables()<cr>a
endfunction
au FileType cucumber call EnableCucumberTables()
au FileType markdown call EnableCucumberTables()
