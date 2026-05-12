set t_Co=256
set termguicolors

set background=dark
colorscheme spectral

function! s:MacOSIsLight() abort
  if !has('macunix')
    return 0
  endif
  silent let l:style = system('defaults read -g AppleInterfaceStyle 2>/dev/null')
  return l:style !~? 'dark'
endfunction

function! s:ApplySpectral() abort
  let l:want = s:MacOSIsLight() ? 'light' : 'dark'
  if get(g:, 'colors_name', '') ==# l:want
    return
  endif
  let &background = l:want
  colorscheme spectral
endfunction

augroup SpectralAppearance
  autocmd!
  autocmd FocusGained * call s:ApplySpectral()
augroup END

call s:ApplySpectral()
