" NeoBundle {{{1

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'


NeoBundle 'bps/vim-textobj-python', { 'rev' : '83c97d9aaae74a7c35b092bae59ef5339723dd9b'}
NeoBundle 'ervandew/supertab.git', { 'rev' : '2.1' }
NeoBundle 'fs111/pydoc.vim', { 'rev' : '2.0' }
NeoBundle 'gavinbeatty/dragvisuals.vim', { 'rev' : 'b6e6d418faf3ec8c40e49c099f82481c820ab098'}
NeoBundle 'godlygeek/tabular', { 'rev' : '60f25648814f0695eeb6c1040d97adca93c4e0bb' }
NeoBundle 'kana/vim-textobj-user',  { 'rev' : '0.7.1' }
NeoBundle 'rking/ag.vim', { 'rev' : 'f755abfb1c4e4e3f59f6cfa25ce16edb5af9e516' }
NeoBundle 'scrooloose/nerdcommenter.git', { 'rev' : '2.3.0' }
NeoBundle 'scrooloose/nerdtree.git', { 'rev' : '4.2.0' }
NeoBundle 'tpope/vim-abolish', { 'rev' : 'v1.1' }
NeoBundle 'tpope/vim-eunuch', { 'rev' : 'v1.1' }
NeoBundle 'tpope/vim-fugitive', { 'rev' : 'v2.2' }
NeoBundle 'tpope/vim-surround', { 'rev' : 'v2.1' }
NeoBundle 'vim-scripts/a.vim', { 'rev' : '2.18' }
NeoBundle 'vim-scripts/snippetsEmu', { 'rev' : '1.2.3'}
NeoBundle 'yannicklm/vimbuddy.vim'
NeoBundle 'yannicklm/vimconf'
NeoBundle 'yannicklm/vim-send-cmd'
NeoBundle 'yannicklm/vim-gnote'
NeoBundle 'kien/ctrlp.vim', { 'rev' : '1.79' }
NeoBundle 'benekastah/neomake'
NeoBundle 'rust-lang/rust.vim'
NeoBundle 'dleonard0/pony-vim-syntax'
NeoBundle 'peterhoeg/vim-qml'

call neobundle#end()

" Simple vim settings {{{1
syntax on
filetype plugin indent on
set history=10000
set mouse=a
set encoding=utf-8
set showcmd
set showmode
set ruler
set backspace=2
set virtualedit=block
set autowriteall
set shiftround
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set nrformats-=octal " don't go from 007 to 010
set hidden

if has("X11")
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" Backups with persistent undos
set backup
let g:dotvim_backups=expand('$HOME') . '/.vim/backups'
if ! isdirectory(g:dotvim_backups)
  call mkdir(g:dotvim_backups, "p")
endif
exec "set backupdir=" . g:dotvim_backups

if has('persistent_undo')
  set undofile
  set undolevels=1000
  set undoreload=10000
  exec "set undodir=" . g:dotvim_backups
endif

" Nicer scrolling
set scroll=5
set scrolloff=2

" This is nice if you have something
" that reset the title of you term at
" each command, otherwize it's annoying ...
set title

" Allow completion on filenames right after a '='.
" Uber-useful when editing bash scripts
set isfname-==

" Disable ex
nnoremap Q gq

" No more annoying bell
set visualbell t_vb=

" Disable useless ctrl+space behavior:
imap <Nul> <Space>

" Always display statusline
set laststatus=2

"For completion:
set wildmenu
set wildignore=*.pyc

" smarter behavior of 'J' (join lines)
set nojoinspaces

" search settings
set nohlsearch
set incsearch
set smartcase

" Remove menu bar from GUI
let did_install_default_menus = 1

" I've always find it weird that it was not this way ...
set splitbelow

" More logical, but not vi-compatible
noremap Y y$
set gdefault
map Q gq

" Jump to last cursor position unless it's invalid or in an event handler
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'git'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  endif
endfunction
" Always load those useful plugins:
runtime! macros/matchit.vim
runtime! ftplugin/man.vim

" These are overloaded in the various ftplugin/ scripts
set shiftwidth=2
set expandtab
set smarttab
set smartindent
set tabstop=4

" Colors {{{1
let os=substitute(system('uname'), '\n', '', '')
" has('mac') only works on macvim ...
if os == 'Darwin' || os == 'Mac'
  set background=light
else
  se background=dark
endif
" Note that GUI stuff is handled in .gvimrc anyway

" Custom functions {{{1
" Remove trailing whitespace
function! CleanWhiteSpace()
  let l = line(".")
  let c = col(".")
  :%s/\s\+$//e
  let last_search_removed_from_history = histdel('s', -1)
  call cursor(l, c)
endfunction()

function! RemoveBlankLinesAtTheEndOfFile()
  let l = line(".")
  let c = col(".")
  :%s#\($\n\s*\)\+\%$##e
  let last_search_removed_from_history = histdel('s', -1)
  call cursor(l, c)
endfunction()

command! -nargs=0 CleanWhiteSpace :call CleanWhiteSpace()
command! -nargs=0 RemoveBlankLinesAtTheEndOfFile :call RemoveBlankLinesAtTheEndOfFile()


" Convert DOS line endings to UNIX line endings

function! FromDos()
  %s/\r//e
endfunction

command! FromDos call FromDos()

" Used to create missing directories before writing a
" buffer
function! MkdirP()
  :!mkdir -p %:h
endfunction

command! MkdirP call MkdirP()

" Plugins customizations {{{1

" Tell snippy to use <C-Space> (tab conflicts with
" supetab)
if has("gui_running")
  let g:snippetsEmu_key = "<C-Space>"
else
  " for some reason when in a term, c-space
  " is interpreted as c-@
  let g:snippetsEmu_key = "<C-@>"
endif

" Status line (requires VimBuddy plugin to be present)
set statusline=%{VimBuddy()}\ [%n]\ %<%f\ %{fugitive#statusline()}%h%m%r%=%-14.(%l,%c%V%)\ %P\ %a

" Fix go syntax file:
let g:go_highlight_array_whitespace_error=0
let g:go_highlight_chan_whitespace_error=0
let g:go_highlight_extra_types=0
let g:go_highlight_space_tab_error=0
let g:go_highlight_trailing_whitespace_error=0

" I find it annoying that fugitive does not define this
function! Gadd()
  w
  !git add %
endfunction

command! Gadd call Gadd()

" Quit Gdiff mode
function! GdiffOff()
  " Close all other windows
  only
  diffoff
endfunction

command! GdiffOff call GdiffOff()

" Autocommands {{{1
" Remove trailing whitespaces when saving:
autocmd bufwritepre * :CleanWhiteSpace
autocmd bufwritepre * :RemoveBlankLinesAtTheEndOfFile

" Spell checking
augroup spell
  autocmd!
  autocmd filetype rst  :setlocal spell spelllang=en
  autocmd filetype tex  :setlocal spell spelllang=en
  autocmd filetype gitcommit  :setlocal spell spelllang=en
augroup end

" Change local working dir upon tab creation
function! TabNewWithCwD(newpath)
  :execute "tabnew " . a:newpath
  if isdirectory(a:newpath)
    :execute "lcd " . a:newpath
  else
    let dirname = fnamemodify(a:newpath, ":h")
    :execute "lcd " . dirname
  endif
endfunction

command! -nargs=1 -complete=file TabNew :call TabNewWithCwD("<args>")


" Special settings from vim files
augroup filetype_vim
  autocmd!
  autocmd filetype vim setlocal foldmethod=marker
  autocmd bufwritepost *.vim :source %
augroup END

" Register more extension for the zip plugin
au BufReadCmd *.jar,*.apk call zip#Browse(expand("<amatch>"))

" Mapping and abbreviations {{{1


" I prefer , for mapleader rather than \
let mapleader=","

nmap <leader>t :CtrlP<CR>
nmap <leader>p :CtrlPMRUFiles<CR>
nmap <leader>b :CtrlPBuffer<CR>

nmap <silent> <leader>/ :set invhlsearch<CR>
nmap <leader>sl :SessionList<CR>
nmap <leader>ss :SessionSave<CR>

" typing :make is much too long anyway
nnoremap <leader>m :make<cr>
nnoremap <leader>M :w<cr>:Neomake!<cr>

" ctrl-^
nnoremap <leader><leader> <c-^>

" Simpler way to go to normal mode from insert mode
inoremap jj <Esc>

" « it's one less key to hit every time I want to save a file »
"     -- Steve Losh (again)
nnoremap ; :
vnoremap ; :

" it's easy to type :X by mistake, and the 'encrypt'
" feature is useless anyway
map :X :x

" use begging-of-history inside command mode
" with ctrl+n ctrl+p
cnoremap <C-N> <Down>
cnoremap <C-P> <Up>
cnoremap %% <C-R>=expand('%h').'/'<cr>

" 'cd' towards the dir in which the current file is edited
" but only change the path for the current window
map <leader>cd :lcd %:h<CR>

" Open files located in the same dir in with the current file is edited
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Navigate through the buffer's list with alt+up, alt+down
nnoremap <M-Down>  :bp<CR>
nnoremap <M-Up>    :bn<CR>

" Man page for work under cursor
nnoremap K :Man <cword> <CR>

" Spell check
cmap spc setlocal spell spelllang=

" Dragging visual blocks
vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" don't try to remove whitespace, :w will do it
let g:DVB_TrimWS=0

" Escape from terminal mode by pressing escape
if has("nvim")
  tnoremap <Esc> <C-\><C-n>
endif
