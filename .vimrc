set nocompatible

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

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
set autoindent
set cindent
set smartindent
set smarttab

let mapleader=","

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

" tir_black looks most like ir_black in console
colorscheme tir_black

if has("gui_running") && has("gui_macvim")

  colorscheme ir_black

  " fullscreen options (MacVim only), resized window when changed to fullscreen
  set fuoptions=maxvert,maxhorz
  set anti

  " Turn on only autoselect, console dialogs and tab pages
  " No menubar, toolbar or scrollbars
  set guioptions=Ace

  " create equally sized splits
  set equalalways
  set splitbelow splitright

  " show relative line numbers (vim 7.3 and up)
  " set nonumber
  " set relativenumber

  " Available when using experimental renderer
  " set transparency=15

  " because it looks bad outside macvim
  " set cursorline

  " max width
  set nowrap
  set textwidth=100
  set formatoptions=qrn1
  " set colorcolumn=101

  " undoing even after closing the file
  set undofile
  set undodir=~/.vim/undo

  set guifont=Dejavu\ Sans\ Mono:h12

  " use par
  set formatprg=par\ -w100

end

" Buffer Explorer opens with Ctrl+B
" nnoremap <C-B> :BufExplorer<cr>

" Always show statusbar
set laststatus=2

" Set the status line
set statusline=%#warningmsg#
set statusline+=%*
set statusline+=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%c\ Buf:%n\ [%b][0x%B]
set statusline+=%{fugitive#statusline()}

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
set scrolloff=15

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
" nnoremap <up> <nop>
" nnoremap <down> <nop>
" nnoremap <left> <nop>
" nnoremap <right> <nop>
" inoremap <up> <nop>
" inoremap <down> <nop>
" inoremap <left> <nop>
" inoremap <right> <nop>
" vnoremap <up> <nop>
" vnoremap <down> <nop>
" vnoremap <left> <nop>
" vnoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" Rename :W to :w
" cmap W w
command! W :w

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

" The size of opened splits by :Vex and :Sex
let g:netrw_winsize=50

" Remove ANY trailing whitespaces in ANY file I save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    %s/\t/  /ge
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()


" http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
" let mapleader=','
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction



" GRB: Put useful info in status line
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red



" Map ,e and ,v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%
map <leader>m :vsplit %%
map <leader>n :split %%




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Running tests
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-makegreen binds itself to ,t unless something else is bound to its
" function.
map <leader>\dontstealmymapsmakegreen :w\|:call MakeGreen('spec')<cr>

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo
    if filereadable("script/test")
        exec ":!script/test " . a:filename
    else
        exec ":!bundle exec rspec -fd " . a:filename
    end
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_spec_file = match(expand("%"), '_spec.rb$') != -1
    if in_spec_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('spec')<cr>
map <leader>c :w\|:!cucumber<cr>
map <leader>C :w\|:!cucumber --profile wip<cr>

nnoremap <c-z> :call RunTestFile()<cr>
nnoremap <c-x> :call RunNearestTest()<cr>
