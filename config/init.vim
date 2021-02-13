call plug#begin(stdpath('data') . '/plugged')
Plug 'csexton/trailertrash.vim'
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go'
Plug 'godlygeek/tabular'
Plug 'itchyny/lightline.vim'
Plug 'janko-m/vim-test'
Plug 'jlanzarotta/bufexplorer'
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/vim-easy-align'
Plug 'kien/ctrlp.vim'
Plug 'luochen1990/rainbow'
Plug 'maximbaz/lightline-ale'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nanotech/jellybeans.vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
call plug#end()

set backup
set history=10000
set hlsearch
set lazyredraw
set nowrap
set nonumber
set nocursorline
set scrolloff=4
set smartcase
set splitbelow splitright
set synmaxcol=512
set timeoutlen=500
set undofile

silent !mkdir -p ~/.local/share/nvim/tmp
set backupdir=~/.local/share/nvim/tmp

if executable('par')
  set formatprg=par\ -w80\ -q
endif

let mapleader = ","

" %% will become the directory of the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" Map ,e and ,v to open files in the same directory as the current file
map <leader>e :edit %%
map <leader>v :view %%
map <leader>m :vsplit %%
map <leader>n :split %%

" Remap return to clear search highlight
nnoremap <silent><cr> :nohlsearch<cr>:ALELint<cr>
" Restore return to default for quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

inoremap jj <ESC>
inoremap jk <ESC>
map <C-C> <ESC>

" Allow :W to save
command! W :w

" A common typo is ":E" when actually meaning ":e" and not ":Explore" or ":Errors".
cnoreabbrev E e

nnoremap <C-B> :BufExplorer<cr>
au BufNewFile,BufRead *.go setlocal noet ts=8 sw=8 sts=8

map <Leader>q :split ~/Dropbox/notes.md<cr>
map <Leader>w :!touch tmp/restart.txt<cr>

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

map <D-S-{> :tabprevious<cr>
map <D-S-}> :tabnext<cr>

augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
    noremap <buffer> <C-l> <c-w>l
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Terminal
"
tnoremap <Esc> <C-\><C-n>
tnoremap <C-v><Esc> <Esc>

" Terminal mode:
tnoremap <C-h> <c-\><c-n><c-w>h
tnoremap <C-j> <c-\><c-n><c-w>j
tnoremap <C-k> <c-\><c-n><c-w>k
tnoremap <C-l> <c-\><c-n><c-w>l
" Insert mode:
inoremap <C-h> <Esc><c-w>h
inoremap <C-j> <Esc><c-w>j
inoremap <C-k> <Esc><c-w>k
inoremap <C-l> <Esc><c-w>l
" Visual mode:
vnoremap <C-h> <Esc><c-w>h
vnoremap <C-j> <Esc><c-w>j
vnoremap <C-k> <Esc><c-w>k
vnoremap <C-l> <Esc><c-w>l
" Normal mode:
nnoremap <C-h> <c-w>h
nnoremap <C-j> <c-w>j
nnoremap <C-k> <c-w>k
nnoremap <C-l> <c-w>l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocomplete
"
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" Smart tab autocomplete behavior
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Aligning
"
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme
"
let g:jellybeans_use_gui_italics = 0
let g:jellybeans_overrides = { 'SignColumn': { 'guibg': '161616', 'ctermbg': '16' } }
let g:jellybeans_background_color = '161616'
colorscheme jellybeans

set fillchars+=vert:│
hi VertSplit ctermbg=NONE guibg=NONE


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Linter configuration (using Ale plugin)
"
" let g:ale_sign_warning = "\uf071 "
let g:ale_sign_warning = "\uf444 "
let g:ale_sign_error = "\uf05e "
" let g:ale_sign_error   = ' !' " has U+2009 as space
" let g:ale_sign_warning = ' •'
let g:ale_sign_column_always = 1
set signcolumn=yes
if filereadable(expand("~/.asdf/shims/ruby"))
  let g:ale_ruby_ruby_executable = expand("~/.asdf/shims/ruby")
endif

" highlight clear ALEErrorSign
" highlight clear ALEWarningSign

highlight SignColumn ctermfg=9 ctermbg=233 guibg=#161616

highlight ALEWarning ctermbg=52 gui=undercurl guisp=#660000
highlight ALEWarningSign ctermfg=9 ctermbg=233 guifg=#7777dd

highlight ALEErrorSign ctermfg=196 ctermbg=233 guifg=#C30500

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
" let g:ale_lint_on_text_changed = 'normal'
" let g:ale_lint_on_text_changed = 'never' " Only run on save
" if you don't want linters to run on opening a file
" let g:ale_lint_on_enter = 0

nmap <silent> <D-k> <Plug>(ale_previous)
nmap <silent> <D-j> <Plug>(ale_next)
nmap <silent> <D-r> :ALEFix rubocop<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-test configuration
"
let test#strategy = "neovim"
" let g:test#preserve_screen = 1
" let test#ruby#rspec#executable = 'rspec_focus'
" let test#ruby#cucumber#executable = 'cucumber_focus'
" let test#ruby#minitest#options = '--color'
" let test#neovim#term_position = "30"
let test#elixir#exunit#options = '--stale'
let test#elixir#exunit#options = {
  \ 'suite':   '--stale',
\}
nmap <silent> <leader>t :up<CR>:TestLast<CR>
nmap <silent> <leader>T :up<CR>:TestFile<CR>
nmap <silent> <leader>r :up<CR>:TestNearest<CR>
nmap <silent> <leader>R :up<CR>:TestSuite --only-failures<CR>
nmap <silent> <leader>g :TestVisit<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fugitive (Git) (follow the <Leader><Leader>)
"
map <Leader><Leader>c :Gcommit<cr>
map <Leader><Leader>b :Gblame<cr>
map <Leader><Leader>s :Gstatus<cr>
map <Leader><Leader>w :Gwrite<cr>
map <Leader><Leader>p :Git push<cr>
map <Leader><Leader>f :Git fetch<cr>
map <Leader><Leader>u :Git up<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Status line configuration (using lightline)
"
" set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left':  [ [ 'mode', 'paste' ], [ 'filename' ], [ 'githead' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ], [ 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'LightlineModified',
      \   'readonly': 'LightlineReadonly',
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'LightlineFilename',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'mode': 'LightlineMode',
      \   'gitbranch': 'FugitiveHead',
      \ },
      \ 'component_expand': {
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_infos': 'lightline#ale#infos',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \   'linter_ok': 'lightline#ale#ok',
      \ },
      \ 'component_type': {
      \   'linter_checking': 'right',
      \   'linter_infos': 'right',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'right',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

function! LightlineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '' : ''
endfunction

" \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? @% : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_infos = "\uf129 "
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "
let g:lightline#ale#indicator_ok = "\uf00c"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ripgrep configuration
"
set wildignore+=*/.git/*,*/tmp/*,*.swp
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vertical alignment configuration (using tabular)
"
" Align = signs
nmap <Leader>a= :Tabularize /=<cr>
vmap <Leader>a= :Tabularize /=<cr>gv
" Align hashrockets
nmap <Leader>a> :Tabularize /=><cr>
vmap <Leader>a> :Tabularize /=><cr>gv
" Align commas
nmap <Leader>a, :Tabularize /,\zs/l1<cr>
vmap <Leader>a, :Tabularize /,\zs/l1<cr>gv
" Align words and fix indentation
nmap <Leader>aw :Tabularize /\s\+\zs/l1<cr>=ip
vmap <Leader>aw :Tabularize /\s\+\zs/l1<cr>gv=gv
" Align comments
nmap <Leader>ac :Tabularize /#<cr>
" Align blocks
nmap <Leader>a{ :Tabularize /{<cr>
vmap <Leader>a{ :Tabularize /{<cr>gv
vmap <Leader>a{ :Tabularize /{<cr>gv

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

function! AlignRubyHashes()
  let p = '^\s*\w\+:\s.*,$'

  " Calculate the range to act. Default Tabularize doesn't do this properly,
  " because the range is determined by a different regex than the alignment
  " regex.
  let from = line('.')
  while (getline(from - 1) =~ p)
    let from -= 1
  endwhile

  let to = line('.')
  while (getline(to + 1) =~ p)
    let to += 1
  endwhile

  " Call Tabularize with the new range
  exe from.','.to.'Tabularize/\(:.*\)\@<!\(:\s\)\zs/l1'
  normal! 0

endfunction

" Align after colons, but only the first one in the line,
" In normal mode, determine range automatically
nmap <Leader>a: :call AlignRubyHashes()<cr>
" In visual mode, the range is already fixed
vmap <Leader>a: :Tabularize/\(:.*\)\@<!:\zs/l1<cr>gv

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rainbow parenthesis configuration
"
let g:rainbow_active = 1
let g:rainbow_conf = {
  \  'guifgs':  [ '#ea8986', '#a4c38c', '#ffc68d', '#a7cae3', '#e8cefb', '#00a7a0' ],
  \  'ctermfgs': ['lightmagenta', 'lightblue', 'lightyellow', 'lightcyan'],
  \  'operators': '_,_',
  \  'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
  \  'separately': {
  \    '*': {},
  \    'tex': { 'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'] },
  \    'vim': { 'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'] },
  \    'html': { 'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'], },
  \    'eruby': { 'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'], },
  \    'css': 0,
  \  }
  \}


" normal
let g:terminal_color_0  = '#a3a3a3' " black
" let g:terminal_color_1  = '#e98885' " red
let g:terminal_color_1  = '#cf6a4c' " red
" let g:terminal_color_2  = '#a3c38b' " green
let g:terminal_color_2  = '#99ad6a' " green
let g:terminal_color_3  = '#ffc68d' " yellow
let g:terminal_color_4  = '#a6cae2' " blue
let g:terminal_color_5  = '#e7cdfb' " magenta
let g:terminal_color_6  = '#00a69f' " cyan
let g:terminal_color_7  = '#888888' " white
" bright
let g:terminal_color_8  = '#888888' " black
let g:terminal_color_9  = '#ffb2b0' " red
let g:terminal_color_10 = '#c8e2b9' " green
let g:terminal_color_11 = '#ffe1af' " yellow
let g:terminal_color_12 = '#bddff7' " blue
let g:terminal_color_13 = '#fce2ff' " magenta
let g:terminal_color_14 = '#0bbdb6' " cyan
let g:terminal_color_15 = '#feffff' " white


map <leader>c :split term://smart-console<cr>i
map <leader>x :split term://ruby -v<cr>i

set shell=zsh-for-neovim
