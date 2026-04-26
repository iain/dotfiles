set t_Co=256
set termguicolors

function! s:MacOSIsLight() abort
  if !has('macunix')
    return 0
  endif
  silent let l:style = system('defaults read -g AppleInterfaceStyle 2>/dev/null')
  return l:style !~? 'dark'
endfunction

function! s:ApplySpectral() abort
  let l:want = s:MacOSIsLight() ? 'spectral-light' : 'spectral'
  if get(g:, 'colors_name', '') ==# l:want
    return
  endif
  let &background = l:want ==# 'spectral-light' ? 'light' : 'dark'
  execute 'colorscheme' l:want
endfunction

augroup SpectralAppearance
  autocmd!
  autocmd FocusGained * call s:ApplySpectral()
augroup END

call s:ApplySpectral()
