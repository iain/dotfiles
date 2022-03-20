" Make vim start out with the same defaults as neovim

set nocompatible
set autoindent
set autoread
set background=dark
set backspace="indent,eol,start"
set belloff="all"
" set complete' excludes "i"
set cscopeverbose
set display="lastline,msgsep"
" set encoding' is UTF-8 (cf. 'fileencoding' for file-content encoding)
" set fillchars' defaults (in effect) to "vert:│,fold:·,sep:│"
set formatoptions="tcqj1"
set nofsync
" set nohidden
set hlsearch
set incsearch
set nojoinspaces
set langnoremap
set nolangremap
set laststatus=2
" set listchars="tab:> ,trail:-,nbsp:+"
set nrformats="bin,hex"
set ruler
" set sessionoptions' includes "unix,slash", excludes "options"
" set shortmess' includes "F", excludes "S"
set showcmd
set sidescroll=1
set smarttab
set nostartofline
set switchbuf="uselast"
set tabpagemax=50
set tags="./tags;,tags;./.ctags"
set ttimeoutlen=50
set ttyfast
" set viewoptions' includes "unix,slash", excludes "options"
" set viminfo' includes "!"
set wildmenu
set wildoptions="pum,tagfile"
