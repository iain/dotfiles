let g:test#preserve_screen = 1
let g:test#vim#term_position = "belowright"
let g:test#ruby#rspec#executable    = './bin/rspec -fd'
let g:test#ruby#cucumber#executable = './bin/cucumber -p all'
let g:test#ruby#minitest#executable = './bin/rake test'
let g:test#ruby#rails#executable    = './bin/rails test'

let g:test#project_root = "."
let g:test#neovim#start_normal = 1 " If using neovim strategy
let g:test#basic#start_normal = 1 " If using basic strategy


function! CustomiTermStrategy(cmd)
  " call s:execute_script('osx_iterm', a:cmd)
  " let script_path = g:test#plugin_path . '/bin/' . a:name
  let cmd = join([shellescape('osx_iterm_vimr'), shellescape(a:cmd)])
  execute 'silent !'.cmd
endfunction

let g:test#custom_strategies = {'custom_iterm': function('CustomiTermStrategy')}
let g:test#strategy = 'custom_iterm'
" let g:test#strategy = 'neovim'

let test#elixir#exunit#options = '--stale'
let test#elixir#exunit#options = {
  \ 'suite':   '--stale',
\}
nmap <silent> <leader>t :up<CR>:TestLast<CR>
nmap <silent> <leader>T :up<CR>:TestFile<CR>
nmap <silent> <leader>r :up<CR>:TestNearest<CR>
nmap <silent> <leader>R :up<CR>:TestSuite --only-failures<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Map ,p to promote variable assignment to let in rspec
map <leader>p :call PromoteToLet()<cr>
function! PromoteToLet()
  :normal! dd
  :exec '?^\s*describe\|fdescribe\|fcontext\|context\|RSpec\.describe\>'
  :normal! p
  :.s/\(\w\+\)\s\+=\s\+\(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
