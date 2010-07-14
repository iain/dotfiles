" Vim indent file
" Language:	SASS
" Maintainer:	Tim Pope <vimNOSPAM@tpope.info>
" Last Change:	2007 Dec 16

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal autoindent sw=2 et
setlocal indentexpr=GetSassIndent()
setlocal indentkeys=o,O,*<Return>,<:>,!^F

" Only define the function once.
if exists("*GetSassIndent")
  "finish
endif

let s:property = '^:\|^[[:alnum:]-]\+\%(:\|\s*=\)'
let s:propertygroup = '^:\|^[[:alnum:]-]\+:$'
let s:mixin = '^\++\|^@[[:alnum:]-_]\+'
let s:vardef = '^$[[:alnum:]-_]\+'

function! GetSassIndent()
  let lnum = prevnonblank(v:lnum-1)
  let line = substitute(getline(lnum),'\s\+$','','')
  let cline = substitute(substitute(getline(v:lnum),'\s\+$','',''),'^\s\+','','')
  let lastcol = strlen(line)
  let line = substitute(line,'^\s\+','','')
  let indent = indent(lnum)
  let cindent = indent(v:lnum)
  if line =~ s:propertygroup && cline =~ s:property
    return indent + &sw
  elseif cline =~ s:property && line !~ s:property && line !~ s:vardef && line !~ s:mixin
    return indent + &sw
  elseif line =~ s:mixin && cline =~ s:property
    return indent
  else
    return -1
  endif
endfunction

" vim:set sw=2:
