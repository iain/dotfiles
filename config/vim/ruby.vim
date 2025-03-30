"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-ruby
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:ruby_indent_assignment_style = 'variable'
" let g:ruby_indent_access_modifier_style = 'normal'
let ruby_operators               = 1
let ruby_pseudo_operators        = 1
let ruby_space_errors            = 1
let ruby_line_continuation_error = 1
let ruby_global_variable_error   = 1
let ruby_minlines                = 250

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sorbet
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! Sorbet()
  syntax region SigBlock start="{" end="}" contained
  syntax region SigBlock start="\<do\>" end="\<end\>" contained

  syntax cluster rubyNotTop add=SigBlock

  syntax match Sig "\<sig\>" nextgroup=SigBlock skipwhite

  syntax match SigExtend "\<extend T::Sig\>" skipwhite

  syntax match rubyMagicComment "\c\%<10l#\s*\zs\%(typed\):" contained nextgroup=rubyBoolean skipwhite

  " highlight link Sig       Comment
  " highlight link SigBlock  Comment
  " highlight link SigExtend Comment

  highlight Comment cterm=italic gui=italic
  " highlight SigExtend cterm=italic gui=italic

  highlight Sig guifg=#6C7086

  highlight link SigBlock Sig
  highlight link SigExtend Sig
endfunction

au FileType ruby call Sorbet()
