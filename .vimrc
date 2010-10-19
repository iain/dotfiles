set nocompatible
syntax on
set background=dark


" Turn on automatic plugin loading
filetype plugin indent on


" Backspace normally
set backspace=indent,eol,start

" I don't care what language I use, 2 spaces per tab!
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Directly switch between open splitted windows
map <C-J> <C-W>j
map <C-H> <C-W>h
map <C-L> <C-W>l
map <C-K> <C-W>k

" Backup and swap files
set backupdir=~/.vim/tmp/
set directory=~/.vim/tmp/

" Normal line numbering
set number

if has("gui_running") && has("gui_macvim")
  colorscheme ir_black
  set fuoptions=maxvert,maxhorz " fullscreen options (MacVim only), resized window when changed to fullscreen
  set anti
  set go-=T " No Toolbar
  set guioptions-=m " No Menubar

  " create equally sized splits
  set equalalways
  set splitbelow splitright

  " show relative line numbers (vim 7.3 and up)
  set nonumber
  set relativenumber

  " because it looks bad outside macvim
  set cursorline

  " max width
  set wrap
  set textwidth=79
  set formatoptions=qrn1
  set colorcolumn=100

  " undoing even after closing the file
  set undofile
  set undodir=~/.vim/undo

  set guifont=Dejavu\ Sans\ Mono:h12

end

" Buffer Explorer opens with Ctrl+B
nnoremap <C-B> :BufExplorer<cr>

" Always show statusbar
set laststatus=2

" Set the status line
set statusline=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%c\ Buf:%n\ [%b][0x%B]

set encoding=utf-8

" nicer looking tabs and whitespace
if (&termencoding == "utf-8") || has("gui_running")
  set listchars=tab:·\ ,trail:\ ,
  set list
  noremap <Leader>i :set list!<CR>
endif

" Don't redraw during macro execution
set lazyredraw

" Don't scroll near the edge
set scrolloff=8

" Turn off beep
set vb t_vb=

" Show the current command in the lower right corner
set showcmd

" Show the current mode
set showmode

" Make the 'cw' and like commands put a $ at the end instead of just deleting
" the text and replacing it
set cpoptions=ces$

" Keep some stuff in the history
set history=100

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=2048

" Turn off arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" Rename :W to :w
cmap W w

" search nonsense
set smartcase
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" Turn off F1
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" in insert mode, jj goes to normal mode
inoremap jj <ESC>
