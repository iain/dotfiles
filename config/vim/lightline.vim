"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lightline: statusline matching the Starship prompt and Spectral colors.
" The 'spectral' lightline theme ships with the colorscheme plugin and
" branches on &background, so the bar tracks the active dark/light variant.
"
" Glyphs use nr2char(0x.., 1) (forced UTF-8) rather than literal bytes.
"
" Truncation priority: a '%<' marker is appended to the mode component, so
" when a window is too narrow Vim removes characters starting there — cwd
" first, then branch, then filename. Everything left of the marker (the
" mode) is always kept. Vim truncates from the left edge without a '%<',
" which is why the mode would otherwise be the first thing cut. The marker
" rides on the mode component rather than a standalone one so lightline
" draws no subseparator pipe around it.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" lightline renders the mode, so drop Vim's native -- INSERT -- line.
set noshowmode

" In a git repo, show just the project (work-tree root) name; otherwise the
" full ~-abbreviated cwd. Resolved via fugitive, so it matches the branch.
function! LightlineCwd() abort
  if exists('*FugitiveWorkTree')
    let l:tree = FugitiveWorkTree()
    if !empty(l:tree)
      return fnamemodify(l:tree, ':t')
    endif
  endif
  return fnamemodify(getcwd(), ':~')
endfunction

" Branch via fugitive. 0xe725 is the devicon git-branch glyph Starship uses.
function! LightlineGitBranch() abort
  if !exists('*FugitiveHead')
    return ''
  endif
  let l:branch = FugitiveHead()
  return empty(l:branch) ? '' : nr2char(0xe725, 1) . ' ' . l:branch
endfunction

" Filename relative to the cwd (falls back to ~-relative, then absolute).
" In netrw there's no file, so show the browsed directory with a folder glyph.
function! LightlineFilename() abort
  if &filetype ==# 'netrw'
    let l:dir = fnamemodify(get(b:, 'netrw_curdir', getcwd()), ':~:.')
    return nr2char(0xf07c, 1) . ' ' . (empty(l:dir) ? './' : l:dir)
  endif
  let l:name = expand('%:~:.')
  return empty(l:name) ? '[No Name]' : l:name
endfunction

let g:lightline = {
  \ 'colorscheme': 'spectral',
  \ 'subseparator': { 'left': '', 'right': '' },
  \ 'active': {
  \   'left':  [ [ 'mode', 'paste' ],
  \              [ 'cwd', 'gitbranch' ],
  \              [ 'readonly', 'filename', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ] ],
  \ },
  \ 'component': {
  \   'mode': '%{lightline#mode()}%<',
  \ },
  \ 'component_function': {
  \   'cwd':       'LightlineCwd',
  \   'gitbranch': 'LightlineGitBranch',
  \   'filename':  'LightlineFilename',
  \ },
  \ }

" lightline-ale: diagnostics counts on the right, glyphs matching ale.vim.
let g:lightline.component_expand = {
  \ 'linter_checking': 'lightline#ale#checking',
  \ 'linter_infos':    'lightline#ale#infos',
  \ 'linter_warnings': 'lightline#ale#warnings',
  \ 'linter_errors':   'lightline#ale#errors',
  \ 'linter_ok':       'lightline#ale#ok',
  \ }

let g:lightline.component_type = {
  \ 'linter_checking': 'right',
  \ 'linter_infos':    'right',
  \ 'linter_warnings': 'warning',
  \ 'linter_errors':   'error',
  \ 'linter_ok':       'right',
  \ }

let g:lightline#ale#indicator_checking = nr2char(0xf110, 1) . ' '
let g:lightline#ale#indicator_infos    = nr2char(0xf129, 1) . ' '
let g:lightline#ale#indicator_warnings = nr2char(0xf444, 1) . ' '
let g:lightline#ale#indicator_errors   = nr2char(0xf05e, 1) . ' '
let g:lightline#ale#indicator_ok       = ''

" Re-source the (background-aware) palette and repaint when the colorscheme
" changes, so the bar follows a dark/light toggle.
function! s:LightlineReload() abort
  if !exists('g:loaded_lightline')
    return
  endif
  runtime autoload/lightline/colorscheme/spectral.vim
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

augroup LightlineSpectral
  autocmd!
  autocmd ColorScheme spectral,spectral-dark,spectral-light call s:LightlineReload()
augroup END
