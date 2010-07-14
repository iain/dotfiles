" Vim Syntax File
" Language:     Config.ru file for Rack applications
" Creator:      Iain Hecker <iain at iain dot nl>
" Last Change:  2010 Feb 26
if version < 600
    syntax clear
endif


runtime syntax/ruby.vim
syntax case match
syntax keyword gemfileKeywords use run
highlight link gemfileKeywords Define


if exists("*TCommentDefineType")
  call TCommentDefineType('Rackup', '# %s')
endif
