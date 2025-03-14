set t_Co=256
set termguicolors     " enable true colors support

function! AfterColorChange()
  set fillchars+=vert:│
  highlight Normal ctermbg=NONE
  highlight SignColumn ctermfg=9 ctermbg=NONE guibg=NONE
  highlight VertSplit ctermbg=NONE guibg=NONE
  highlight Search guibg=NONE guifg=HotPink
endfunction

function! LightMode()
  set background=light
  colorscheme catppuccin-latte
  call AfterColorChange()
endfunction

function! DarkMode()
  set background=dark
  colorscheme catppuccin-mocha
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
