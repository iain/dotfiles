" Directly switch between open splitted windows
map <C-J> <C-W>j
map <C-H> <C-W>h
map <C-L> <C-W>l
map <C-K> <C-W>k

" The size of opened splits by :Vex and :Sex
let g:netrw_winsize=50

" Map ,e and ,v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%
map <leader>m :vsplit %%
map <leader>n :split %%

" create equally sized splits
set equalalways
set splitbelow splitright

" Fast window resizing with +/- keys (horizontal); / and * keys (vertical)
" only keypad
if bufwinnr(1)
  map <kPlus> 5<C-W>+
  map <kMinus> 5<C-W>-
  map <kDivide> 5<c-w><
  map <kMultiply> 5<c-w>>
endif