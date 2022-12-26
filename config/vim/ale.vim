"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keymaps:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use Cmd+k / Cmd+j to jump between linter failures
nmap <silent> <D-k> <Plug>(ale_previous)
nmap <silent> <D-j> <Plug>(ale_next)

" Use Cmd+r to fix ruby linter errors
nmap <silent> <D-r> :ALEFix<CR>

" Use Enter to lint
nnoremap <silent><cr> :nohlsearch<cr>:ALELint<cr>

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Linters:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ale_linters = {
  \ 'javascript':  ['eslint'],
  \ 'json':        ['jsonlint'],
  \ 'markdown':    ['prettier'],
  \ 'eruby':       ['erblint'],
  \ 'ruby':        ['ruby', 'rubocop']
  \ }

let g:ale_fixers = {
  \ 'css':         ['prettier'],
  \ 'javascript':  ['eslint', 'prettier'],
  \ 'json':        ['jq'],
  \ 'markdown':    ['prettier'],
  \ 'ruby':        ['rubocop'],
  \ 'yaml':        ['prettier'],
  \ 'rust':        ['rustfmt'],
  \ 'go':          ['gofmt'],
  \ 'html':        ['prettier'],
  \ '*':           ['remove_trailing_lines', 'trim_whitespace']
  \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ale_sign_column_always = 1

if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
  " Always open sign column, so no sudden shifts
endif

" Using Nerd Font icons from https://www.nerdfonts.com/
let g:ale_sign_warning = "\uf444 "
let g:ale_sign_error = "\uf05e "

" Color the sign column
highlight ALEWarning ctermbg=52 gui=undercurl guisp=#660000
highlight ALEWarningSign ctermfg=9 ctermbg=NONE guifg=#7777dd
highlight ALEErrorSign ctermfg=196 ctermbg=NONE guifg=#C30500

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rubocop:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ruby_indent_assignment_style = 'variable'

let g:ale_ruby_rubocop_auto_correct_all = 1

" Use Ruby from ASDF if available
if filereadable(expand("~/.asdf/shims/ruby"))
  let g:ale_ruby_ruby_executable = expand("~/.asdf/shims/ruby")
endif

if filereadable(expand("~/.dotfiles/bin/rubocop"))
  let g:ale_ruby_rubocop_executable = expand("~/.dotfiles/bin/rubocop")
endif

" Use `rubocop-daemon-wrapper` instead of `rubocop`
" let g:ale_ruby_rubocop_executable = 'rubocop-daemon-wrapper-netcat'
" ['brakeman', 'debride', 'rails_best_practices', 'reek', 'rubocop', 'ruby', 'solargraph', 'sorbet', 'standardrb']
