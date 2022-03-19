set hlsearch
set smartcase
set gdefault

" set wildmode=list:longest,full

set wildignore+=*.so
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.gif,*.jpg,*.png,*.log
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*
set wildignore+=*/public/assets/*
set wildignore+=*.swp,*~,._*
set wildignore+=.DS_Store

if executable('rg')
  set grepprg=rg\ --color=never\ --vimgrep\ --no-heading\ --smart-case
  " let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  " let g:ctrlp_use_caching = 0
endif

if executable('fzf')
  set rtp+=/usr/local/opt/fzf
endif
