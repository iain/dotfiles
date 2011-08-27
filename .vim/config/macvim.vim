" My favorite color scheme, only slightly adjusted
colorscheme ir_black

" Antialias
set antialias

" Turn on only autoselect, console dialogs and tab pages
" No menubar, toolbar or scrollbars, as minimal as possible
set guioptions=Ace

" create equally sized splits
set equalalways
set splitbelow splitright

" show relative line numbers (vim 7.3 and up)
" you need to turn of normal line numbers first
" set nonumber
" set relativenumber

" Get Dejavu Sans mono here: http://dejavu-fonts.org/
set guifont=Dejavu\ Sans\ Mono:h12

" use par
set formatprg=par\ -w100

" Turn off beep
set vb t_vb=

" fullscreen options (MacVim only), resized window when changed to fullscreen
"
" If you are on OSX Lion, and you hate Lion's native full screen, turn it off for macvim:
"
"   defaults write org.vim.MacVim MMNativeFullScreen 0
"
" Press Ctrl+Cmd+F to go full screen.
set fuoptions=maxvert,maxhorz

" Available when using experimental renderer in macvim
" set transparency=15
