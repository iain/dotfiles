"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-ruby
"
" Configuration for the vim-ruby plugin. Enables stricter error highlighting
" and sets indentation preferences for Ruby files.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Indent continuation lines to match the variable, not the assignment operator
let g:ruby_indent_assignment_style = 'variable'

" Indent access modifiers (public/private/protected) one level inside the class
let g:ruby_indent_access_modifier_style = 'normal'

" Highlight operators and pseudo-operators (e.g. and, or, not)
let ruby_operators        = 1
let ruby_pseudo_operators = 1

" Highlight common Ruby mistakes
let ruby_space_errors            = 1
let ruby_line_continuation_error = 1
let ruby_global_variable_error   = 1

" Number of lines to scan for syntax highlighting (higher = more accurate)
let ruby_minlines = 250
