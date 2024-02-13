set t_Co=256
set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
let g:ayucolor="mirage" " for mirage version of theme
set background=dark
let &background = "dark"
" let ayucolor="dark"   " for dark version of theme

function! AfterColorChange()
  set fillchars+=vert:│
  highlight Normal ctermbg=NONE
  highlight SignColumn ctermfg=9 ctermbg=NONE guibg=NONE
  highlight VertSplit ctermbg=NONE guibg=NONE
  highlight Search guibg=NONE guifg=HotPink
  set termguicolors
endfunction

function! LightMode()
  set background=light
  let g:ayucolor="light"
  colorscheme ayu
  " colorscheme nofrils-acme
  " colorscheme shoji_niji
  " colorscheme shoji_shiro
  " colorscheme wildcharm
  call AfterColorChange()
endfunction

function! DarkMode()
  let ayucolor="mirage"
  set background=dark
  colorscheme ayu
  " colorscheme wildcharm
  " colorscheme nofrils-dark
  " colorscheme farout
  " colorscheme yami
  " colorscheme darktheme
  call AfterColorChange()
endfunction

function! ChangeBackground()
  set termguicolors
  " call DarkMode()
  " redraw!

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

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" noremap <C-s> :call ShojiToggle()<return>
