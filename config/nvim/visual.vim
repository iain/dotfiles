set lazyredraw

" Give more space for displaying messages.
" set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
set timeoutlen=500
set synmaxcol=512

set nonumber
" set relativenumber
set nocursorline
set scrolloff=4
set sidescrolloff=5
set scrolljump=8      " Scroll 8 lines at a time at bottom/top
set diffopt+=vertical " Diff in vertical mode by default
set winminheight=0

set list
set listchars=                " Reset listchars
set listchars+=tab:▸\         " Symbols to use for invisible characters
set listchars+=trail:·        " trailing whitespace
set listchars+=nbsp:•         " non-breaking space
set listchars+=extends:→      " line continues beyond right of the screen
" set listchars+=eol:↵
set listchars+=precedes:↶

set statusline=%f       "filename
set statusline+=\ %h    "help file flag
set statusline+=%q      "quickfix list or location
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%=      "left/right separator
set statusline+=%y      "filetype
set statusline+=\ %c,   "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

set linebreak
let &showbreak = '↳ '
set breakindent
set breakindentopt=sbr

set modeline " always show modeline
set modelines=2

set ruler          " Show the ruler
set showcmd        " Show partial commands in status line and Selected characters/lines in visual mode
set showmode       " Show current mode in command-line
set showmatch      " Show matching brackets/parentthesis
set matchtime=5    " Show matching time
set report=0       " Always report changed lines
set linespace=0    " No extra spaces between rows
set pumheight=20   " Avoid the pop up menu occupying the whole screen

set mousehide      " Hide the mouse cursor while typing

set shortmess=atOIc

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

" http://stackoverflow.com/questions/6427650/vim-in-tmux-background-color-changes-when-paging/15095377#15095377
set t_ut=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Splits:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set splitbelow splitright

inoremap <C-h> <Esc><c-w>h
inoremap <C-j> <Esc><c-w>j
inoremap <C-k> <Esc><c-w>k
inoremap <C-l> <Esc><c-w>l
vnoremap <C-h> <Esc><c-w>h
vnoremap <C-j> <Esc><c-w>j
vnoremap <C-k> <Esc><c-w>k
vnoremap <C-l> <Esc><c-w>l
nnoremap <C-h> <c-w>h
nnoremap <C-j> <c-w>j
nnoremap <C-k> <c-w>k
nnoremap <C-l> <c-w>l

" %% will become the directory of the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" Map ,e and ,v to open files in the same directory as the current file
map <leader>e :edit %%
map <leader>v :view %%
map <leader>m :vsplit %%
map <leader>n :split %%


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabs:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set tabpagemax=50

nnoremap <silent><D-S-{> :tabprevious<cr>
nnoremap <silent><D-S-}> :tabnext<cr>
inoremap <silent><D-S-{> <Esc>:tabprevious<cr>
inoremap <silent><D-S-}> <Esc>:tabnext<cr>
