"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cucumber JS/TS support
"
" Widens b:cucumber_steps_glob to include .ts/.js files so vim-cucumber's
" built-in navigation ([<C-D>, ]<C-D>) and omnicomplete scan them too.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType cucumber call s:SetupCucumberJS()

function! s:SetupCucumberJS()
  if !exists('b:cucumber_root')
    return
  endif

  for l:name in ['package.json', 'cucumber.mjs', 'cucumber.js', 'cucumber.cjs']
    if filereadable(b:cucumber_root . '/' . l:name)
      let b:cucumber_steps_glob = b:cucumber_root . '/**/*.ts,'
        \ . b:cucumber_root . '/**/*.js,'
        \ . b:cucumber_root . '/**/*.rb'
      return
    endif
  endfor
endfunction
