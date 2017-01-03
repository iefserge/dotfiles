set nocompatible                   " Use Vim settings (must be first)

" =============================================================================
" General
" =============================================================================
set backspace=indent,eol,start     " Allow backspacing over everything in insert mode
set history=1000                   " Keep lots of lines of command line history

set ttimeout                       " Time out for key codes
set ttimeoutlen=100                " Wait up to 100ms after Esc for special key

set number                         " Show line numbers
set ruler                          " Show the cursor position all the time
set showcmd                        " Display incomplete commands
set showmode                       " Show current mode down the bottom
set title                          " Nicer process title

set ttyfast
set gcr=a:blinkon0                 " Disable cursor blink
set visualbell t_vb=               " No blinking
set autoread                       " Reload files changed outside vim
set nrformats-=octal               " Do not recognize octal numbers for Ctrl-A and Ctrl-X

set hidden                         " Enable background buffers

syntax on                          " Turn on syntax highlighting
filetype on                        " Filetype highlighting options
filetype plugin on
filetype indent on

let mapleader=","                  " Map leader key to ,

nnoremap ' `                       " Jump to line and column key
nnoremap ` '                       " Jump to line key

map Q gq                           " Don't use Ex mode, use Q for formatting

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Allow color schemes to do bright colors without forcing bold
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" UTF-8 encoding
if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

" Background and colors
set background=dark
if !has('gui_running')
  set t_Co=256
endif

scriptencoding utf-8
" =============================================================================
" Indentation
" =============================================================================
set autoindent
set smartindent
set smarttab
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

set nowrap                         " Don't wrap lines
set linebreak                      " Wrap lines at convenient points

set list listchars=tab:\ \ ,trail:·  " Display tabs and trailing spaces visually

" =============================================================================
" Completion
" =============================================================================
set wildmode=list:longest          " Better completion
set wildmenu                       " Display completion matches in a status line
set wildignore=*.o,*.obj,*~        " Ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*DS_Store*

" =============================================================================
" Scrolling
" =============================================================================
set scrolloff=8                    " Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" =============================================================================
" Search
" =============================================================================
set incsearch                      " Incremental searching
set hlsearch                       " Highlight searches by default
set ignorecase                     " Ignore case when searching
set smartcase                      " Ignore case unless we type a capital

" =============================================================================
" Backup/Swap/Undo
" =============================================================================
" Save your backup files to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or .
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" Save your swap files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" Viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backup files, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

" Save and restore last edited line
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" =============================================================================
" Keys
" =============================================================================
" Move between splits
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-l> <C-w>l
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-j> <C-w>j

" Double tap // to clear highlight
nmap <silent> // :nohlsearch<CR>

" =============================================================================
" Auto-install and setup vim-plug
" =============================================================================
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

" =============================================================================
" Nerdtree file browser
" =============================================================================
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }

" Remove 'press ? for help'
let NERDTreeMinimalUI=1

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Locate current file in the tree
" Calls NERDTreeFind if NERDTree is active, current window contains a
" modifiable file, and we're not in vimdiff
function! OpenNerdTree()
  if &modifiable && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
  else
    NERDTreeToggle
  endif
endfunction
nnoremap <silent> <C-\> :call OpenNerdTree()<CR>

" =============================================================================
" Nicer status line
" =============================================================================
Plug 'itchyny/lightline.vim'
set laststatus=2                   " Always show status line
set noshowmode                     " Don't show mode in default vim cmdline
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

" =============================================================================
" Theme
" =============================================================================
Plug 'nanotech/jellybeans.vim', { 'tag': 'v1.6' }

" =============================================================================
" Comment line/block keys
" =============================================================================
Plug 'tomtom/tcomment_vim'

" =============================================================================
" Buffer/file navigation
" =============================================================================
Plug 'ctrlpvim/ctrlp.vim'

" Buffer search
nnoremap <silent> ,b :CtrlPBuffer<cr>

" Ag search
if exists("g:ctrlp_user_command")
  unlet g:ctrlp_user_command
endif
if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command =
    \ 'ag %s --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$"'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
else
  " Fall back to using git ls-files if Ag is not available
  let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']
endif

" =============================================================================
" Syntax highlighter
" =============================================================================
Plug 'sheerun/vim-polyglot'

" =============================================================================
" Insert mode auto-completion for quotes, parens, brackets
" =============================================================================
Plug 'Raimondi/delimitMate'

" =============================================================================
" Code-completion
" =============================================================================
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }

" =============================================================================
" Better iTerm2 integration
" =============================================================================
Plug 'sjl/vitality.vim'

" =============================================================================
" Fix * in visual mode
" =============================================================================
Plug 'nelstrom/vim-visual-star-search'

" =============================================================================
" End Plugins
" =============================================================================
call plug#end()

" =============================================================================
" Theme settings
" =============================================================================
colorscheme jellybeans
