set nocompatible

" Manage filetypes
" =============================================================================
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,perl,tex set shiftwidth=2

augroup filetypedetect
  au! BufNewFile,BufRead *.ch setf cheat
  au BufNewFile,BufRead *.liquid setf liquid
  au! BufRead,BufNewFile *.haml setfiletype haml
  autocmd BufNewFile,BufRead *.yml setf eruby
augroup END

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
augroup END


" Syntax
" =============================================================================
syntax on
colorscheme ir_black

set nobackup
set nowritebackup


" Tabs and stuff
" =============================================================================
set ts=2
set bs=2
set sw=2
set nocp incsearch
set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr
set cindent
set autoindent
set smarttab
set expandtab



" Concerning the width
" =============================================================================
set nowrap
set textwidth=80

" NOT put a carriage return at the end of the last line! if you are programming
" for the web the default will cause http headers to be sent. that's bad.
" =============================================================================
set binary noeol

" make that backspace key work the way it should
set backspace=indent,eol,start

" GUI stuff
" =============================================================================
if has("gui_running")

	set anti
  set go-=T " No Toolbar
  set guioptions-=m " No Menubar
  set number

	set hlsearch

	filetype plugin indent on

	if has("gui_macvim")
		set fuoptions=maxvert,maxhorz " fullscreen options (MacVim only), resized window when changed to fullscreen
	end

end

" Control-B shows the bufexplorer
" =============================================================================
nnoremap <C-B> :BufExplorer<cr>

" Mark whitespace at the end of lines as errors
" =============================================================================
hi link localWhitespaceError Error
au Syntax * syn match localWhitespaceError /\(\zs\%#\|\s\)\+$/ display
au Syntax * syn match localWhitespaceError / \+\ze\t/ display

" Color the statusline red when in insert mode, green in normal mode
" =============================================================================
" first, enable status line always
set laststatus=2
" now set it up to change the status line based on mode
if version >= 700
  au InsertEnter * hi StatusLine ctermfg=0 ctermbg=1 guibg=#000000 guifg=#990000
  au InsertLeave * hi StatusLine ctermfg=0 ctermbg=2 guibg=#000000 guifg=#009900
endif


" Search options
" =============================================================================
" visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

" Control P clears search highlighting and redraw
nnoremap <C-P> :nohls<CR><C-P>
inoremap <C-P> <C-O>:nohls<CR>



" Windows
" =============================================================================
set equalalways " Multiple windows, when created, are equal in size
set splitbelow splitright

" Directly switch between open splitted windows
map <C-J> <C-W>j
map <C-H> <C-W>h
map <C-L> <C-W>l
map <C-K> <C-W>k

set vb t_vb= " Turn off bell

" Make tab in v mode work like I think it should (keep highlighting):
vmap <tab> >gv
vmap <s-tab> <gv


" Configure a giant status line
" =============================================================================
" set statusline=%<%f\ %h%m%r%=%-20.(line=%l,col=%c%V,totlin=%L%)\%h%m%r%=%-40(,%n%Y%)\%P
set statusline=
set statusline+=%3.3n\ " buffer number
set statusline+=%f\ " file name
set statusline+=%h%1*%m%r%w%0* " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}%{&bomb?'/bom':''}, " encoding
set statusline+=%{&fileformat}] " file format
set statusline+=%{exists('loaded_VCSCommand')?VCSCommandGetStatusLine():''} " show vcs status
set statusline+=%{exists('loaded_scmbag')?SCMbag_Info():''} " show vcs status
set statusline+=%= " right align
set statusline+=0x%-8B\ " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P " offset
