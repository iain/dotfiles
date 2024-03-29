"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" terminal colors
"

" normal
let g:terminal_color_0  = '#888888' " black
let g:terminal_color_1  = '#cf6a4c' " red
let g:terminal_color_2  = '#99ad6a' " green
let g:terminal_color_3  = '#fabb6e' " yellow
let g:terminal_color_4  = '#8197bf' " blue
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
let g:terminal_color_15 = '#e8e8d3' " white

" Install vim-plugged in needed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'AndrewRadev/splitjoin.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'bogado/file-line'
Plug 'csexton/trailertrash.vim'
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go'
Plug 'godlygeek/tabular'
Plug 'janko-m/vim-test'
Plug 'jlanzarotta/bufexplorer'
" Plug 'jremmen/vim-ripgrep'
Plug 'lamchau/vim-ripgrep', { 'branch': 'patch-1' }
Plug 'junegunn/vim-easy-align'
Plug 'kien/ctrlp.vim'
Plug 'luochen1990/rainbow'
Plug 'michaeljsmith/vim-indent-object'
Plug 'segeljakt/vim-silicon'
Plug 'sheerun/vim-polyglot'
Plug 'thiagoalessio/rainbow_levels.vim'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
call plug#end()

set backupdir=~/.local/share/nvim/tmp/
set directory=~/.local/share/nvim/swap/
set undodir=~/.local/share/nvim/undo/

set backup
set history=10000
set hlsearch
set lazyredraw


set nonumber
set nocursorline
set scrolloff=4
set sidescrolloff=5
set scrolljump=8        " Scroll 8 lines at a time at bottom/top
set smartcase
set splitbelow splitright
set synmaxcol=512
set timeoutlen=500
set undofile
set gdefault
set autoread
set ttyfast         " smoother changes
set wildmenu
set tabpagemax=50

set list
set listchars=                " Reset listchars
set listchars+=tab:▸\         " Symbols to use for invisible characters
set listchars+=trail:·        " trailing whitespace
set listchars+=nbsp:•         " non-breaking space
set listchars+=extends:→      " line continues beyond right of the screen

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

set backspace=indent,eol,start

set formatoptions+=1          " Do not wrap after a one-letter word
set formatoptions+=j          " Remove extra comment when joining lines
set diffopt+=vertical         " Diff in vertical mode by default

set wrap
set linebreak
let &showbreak = '↳ '
set breakindent
set breakindentopt=sbr

set modeline                  " always show modeline
set modelines=2
set shiftround                " round shifts to a multiple of shiftwidth
set nojoinspaces              " prevent inserting two spaces after punctuation

" For MacVim
set noimd
set imi=1
set ims=-1

digraphs .. 8230              " Ellipsis  (…) mapped to '..'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"
" set foldmethod=syntax
set foldmethod=indent
let ruby_foldable_groups = 'def do'

" automatically save and load folds
" au BufWinLeave * mkview
" au BufWinEnter * silent loadview

" Sets the fold level: Folds with a higher level will be closed.  Setting
" this option to zero will close all folds.  Higher numbers will close fewer
" folds.
" set foldlevel=10
" set foldnestmax=10
set nofoldenable   " start with all folds open (toggle via zi)
" set foldlevel=9 " Start with all folds open
" set foldenable
" set foldlevelstart=0
" set foldnestmax=10

"" Enable folding based on syntax rules

"" Map folding to Spacebar
" nnoremap  za

set wildignore+=*.so
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.gif,*.jpg,*.png,*.log
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*
set wildignore+=*/public/assets/*
set wildignore+=*.swp,*~,._*
set wildignore+=.DS_Store

au BufNewFile,BufRead *.go setlocal noet ts=8 sw=8 sts=8


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Config
"
let mapleader = ","

" Go up and down display lines in soft line breaks
nnoremap j gj
nnoremap k gk

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

" Common Command Typos
command! Q  quit    " converts ... :Q  => :q
command! W  write   " converts ... :W  => :w
command! Wq wq      " converts ... :Wq => :wq
command! Wn wn      " converts ... :Wn => :wn
command! WN wN      " converts ... :WN => :wN

" A common typo is ":E" when actually meaning ":e" and not ":Explore" or ":Errors".
cnoreabbrev E e

" in insert mode, jj or jk goes to normal mode
" if you ever need to type jj for real, type it slowly, like on old school mobile phones
inoremap jj <ESC>
inoremap jk <ESC>
map <C-C> <ESC>

" Shift+K becomes similar to Shift+J
nnoremap <S-k> kJ

" Remap return to clear search highlight
nnoremap <silent><cr> :nohlsearch<cr>:ALELint<cr>
" Restore return to default for quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

nnoremap <C-B> :BufExplorer<cr>

" Open notes file
map <Leader>q :split ~/Dropbox/notes.md<cr>

map <Leader>w :!touch tmp/restart.txt<cr>

" %% will become the directory of the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Map ,e and ,v to open files in the same directory as the current file
map <leader>e :edit %%
map <leader>v :view %%
map <leader>m :vsplit %%
map <leader>n :split %%

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

" Fix netrw Ctrl+L
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
    noremap <buffer> <C-l> <c-w>l
endfunction

let g:netrw_cursor=0

" tabs in VimR
map <D-S-{> :tabprevious<cr>
map <D-S-}> :tabnext<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocomplete
"
set tags=./.ctags;
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
" Linter configuration (using Ale plugin)
"

" Use Ruby from ASDF if available
if filereadable(expand("~/.asdf/shims/ruby"))
  let g:ale_ruby_ruby_executable = expand("~/.asdf/shims/ruby")
endif

" if filereadable(expand("~/.asdf/shims/rubocop"))
"   let g:ale_ruby_rubocop_executable = expand("~/.asdf/shims/rubocop")
" endif

" Use `rubocop-daemon-wrapper` instead of `rubocop`
" let g:ale_ruby_rubocop_executable = 'rubocop-daemon-wrapper-netcat'
" ['brakeman', 'debride', 'rails_best_practices', 'reek', 'rubocop', 'ruby', 'solargraph', 'sorbet', 'standardrb']

" let g:ale_ruby_rubocop_options = ''

" Always open sign column, so no sudden shifts
let g:ale_sign_column_always = 1
set signcolumn=yes

" Using Nerd Font icons from https://www.nerdfonts.com/
let g:ale_sign_warning = "\uf444 "
let g:ale_sign_error = "\uf05e "

" Color the sign column
highlight ALEWarning ctermbg=52 gui=undercurl guisp=#660000
highlight ALEWarningSign ctermfg=9 ctermbg=NONE guifg=#7777dd
highlight ALEErrorSign ctermfg=196 ctermbg=NONE guifg=#C30500

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
" Set this variable to 1 to fix files when you save them.
" let g:ale_fix_on_save = 1

" Use Cmd+k / Cmd+j to jump between linter failures
nmap <silent> <D-k> <Plug>(ale_previous)
nmap <silent> <D-j> <Plug>(ale_next)

" Use Cmd+r to fix ruby linter errors
nmap <silent> <D-r> :ALEFix<CR>

let g:ale_linters = {
  \ 'javascript':  ['eslint'],
  \ 'json':        ['jsonlint'],
  \ 'markdown':    ['prettier'],
  \ 'ruby':        ['ruby', 'rubocop']
  \ }

let g:ale_fixers = {
  \ 'css':         ['prettier'],
  \ 'javascript':  ['eslint', 'prettier'],
  \ 'json':        ['jq'],
  \ 'markdown':    ['prettier'],
  \ 'ruby':        ['rubocop'],
  \ 'yaml':        ['prettier'],
  \ '*':           ['remove_trailing_lines', 'trim_whitespace']
  \ }

let g:ale_ruby_rubocop_auto_correct_all = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ripgrep configuration
"
set wildignore+=*/.git/*,*/tmp/*,*.swp
if executable('rg')
  set grepprg=rg\ --color=never\ --vimgrep\ --no-heading\ --smart-case
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ripgrep configuration
"
if executable('par')
  set formatprg=par\ -w80\ -q
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF fuzzy file finder configuration
"
if executable('fzf')
  set rtp+=/usr/local/opt/fzf
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
  \  'guifgs':  [ '#ff9940', '#55b4d4', '#86b300', '#a37acc' ],
  \  'ctermfgs': ['lightmagenta', 'lightblue', 'lightyellow', 'lightcyan'],
  \  'operators': '_,_',
  \  'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
  \}
map <F5> :RainbowLevelsToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-test configuration
"
let g:test#preserve_screen = 1
let g:test#vim#term_position = "belowright"
let g:test#ruby#rspec#executable    = './bin/rspec -fd'
let g:test#ruby#cucumber#executable = './bin/cucumber -p all'
" let g:test#ruby#minitest#executable = 'rake test'
" let g:test#ruby#rails#executable    = 'rails test'

let g:test#project_root = "."
let g:test#neovim#start_normal = 1 " If using neovim strategy
let g:test#basic#start_normal = 1 " If using basic strategy


function! CustomiTermStrategy(cmd)
  " call s:execute_script('osx_iterm', a:cmd)
  " let script_path = g:test#plugin_path . '/bin/' . a:name
  let cmd = join([shellescape('osx_iterm_vimr'), shellescape(a:cmd)])
  execute 'silent !'.cmd
endfunction

let g:test#custom_strategies = {'custom_iterm': function('CustomiTermStrategy')}
" let g:test#strategy = 'custom_iterm'
let g:test#strategy = 'neovim'

let test#elixir#exunit#options = '--stale'
let test#elixir#exunit#options = {
  \ 'suite':   '--stale',
\}
nmap <silent> <leader>t :up<CR>:TestLast<CR>
nmap <silent> <leader>T :up<CR>:TestFile<CR>
nmap <silent> <leader>r :up<CR>:TestNearest<CR>
nmap <silent> <leader>R :up<CR>:TestSuite --only-failures<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Map ,p to promote variable assignment to let in rspec
map <leader>p :call PromoteToLet()<cr>
function! PromoteToLet()
  :normal! dd
  :exec '?^\s*describe\|fdescribe\|fcontext\|context\|RSpec\.describe\>'
  :normal! p
  :.s/\(\w\+\)\s\+=\s\+\(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction

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
" terminal configuration
"

" Jellybeans colors
let g:terminal_ansi_colors = [ '#888888', '#cf6a4c', '#99ad6a', '#fabb6e', '#8197bf', '#e7cdfb', '#00a69f', '#888888', '#888888', '#ffb2b0', '#c8e2b9', '#ffe1af', '#bddff7', '#fce2ff', '#0bbdb6', '#e8e8d3' ]

tnoremap <Esc> <C-\><C-n>
tnoremap <C-v><Esc> <Esc>

" Terminal mode:
tnoremap <C-h> <c-\><c-n><c-w>h
tnoremap <C-j> <c-\><c-n><c-w>j
tnoremap <C-k> <c-\><c-n><c-w>k
tnoremap <C-l> <c-\><c-n><c-w>l


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual
"
" set guifont=Hack\ Nerd\ Font:h15
" set guifont=Comic\ Mono:h15
set guioptions=Ace " No menubar, toolbar or scrollbars, as minimal as possible
set vb t_vb= " Turn off beeping
" set macthinstrokes

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" silicon
"

let g:silicon = {
\ 'default-file-pattern': '~/Desktop/silicon-{time:%Y-%m-%d-%H%M%S}.png',
\ }
" \ 'theme': '/Users/coreyja/themer-theme/output/sublime-text/themer-sublime-text-dark.tmTheme',

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Switching
"
set t_Co=256
set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme

function! AfterColorChange()
  set fillchars+=vert:│
  highlight Normal ctermbg=NONE
  highlight SignColumn ctermfg=9 ctermbg=NONE guibg=NONE
  highlight VertSplit ctermbg=NONE guibg=NONE
  highlight Search guibg=NONE guifg=HotPink
endfunction

function! LightMode()
  set background=light
  let g:ayucolor='light'
  colorscheme ayu
  call AfterColorChange()
endfunction

function! DarkMode()
  set background=dark
  let g:ayucolor='mirage'
  colorscheme ayu
  call AfterColorChange()
endfunction

function! ChangeBackground()
  if system("dark-mode status") == "off\n"
    call LightMode()
  else
    call DarkMode()
  endif
  redraw!
endfunction

if has("gui_macvim")
  au OSAppearanceChanged * call ChangeBackground()
endif

call ChangeBackground()
