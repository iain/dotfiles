set nowrap

set shiftround " round shifts to a multiple of shiftwidth
set expandtab  " Tabs are spaces, not tabs

set formatoptions+=1  " Do not wrap after a one-letter word
set formatoptions+=j  " Remove extra comment when joining lines

" par is a utility that is really good at wrapping lines
if executable('par')
  set formatprg=par\ -w110\ -q
endif

" Go up and down display lines in soft line breaks
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
