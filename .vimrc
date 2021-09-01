set nocompatible                   " Use Vim settings (must be first)

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
set noshowmode                     " Don't show mode in default vim cmdline
set noshowcmd

set nocursorline
set lazyredraw
set laststatus=2                   " Always show status line
set hidden                         " Enable background buffers
set mmp=2000
set signcolumn=yes

syntax on                          " Turn on syntax highlighting
filetype on                        " Filetype highlighting options
filetype plugin on
filetype indent on

set re=1                           " Faster syntax regex engine
let loaded_matchparen = 1
let mapleader=","                  " Map leader key to ,

nnoremap ' `                       " Jump to line and column key
nnoremap ` '                       " Jump to line key

map Q gq                           " Don't use Ex mode, use Q for formatting

set textwidth=80 colorcolumn=+1

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

scriptencoding utf-8

set tags=./tags,tags;$HOME
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
tnoremap <silent> <C-h> <C-w>h
tnoremap <silent> <C-l> <C-w>l
tnoremap <silent> <C-k> <C-w>k
tnoremap <silent> <C-j> <C-w>j

" =============================================================================
" Terminal
" =============================================================================
tnoremap <C-k> clear<CR>
nnoremap <Leader>t :vert botright term<CR>
tnoremap <c-b> <c-\><c-n>
tnoremap <Esc><Esc> <c-\><c-n>
autocmd TerminalOpen * set nonu

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

" =============================================================================
" Comment line/block keys
" =============================================================================
Plug 'tomtom/tcomment_vim'

" =============================================================================
" Buffer/file navigation
" =============================================================================
let g:ctrlp_cmd = 'GFiles'
Plug 'ctrlpvim/ctrlp.vim'

" Buffer search
nnoremap <silent> ,b :CtrlPBuffer<cr>

" =============================================================================
" Async runner
" =============================================================================
let g:asyncrun_open = 8
Plug 'skywind3000/asyncrun.vim'

nnoremap ; :cfirst <cr>
nnoremap ' :cnext <cr>

" =============================================================================
" CMake
" =============================================================================
let g:cmake_console_size=3
let g:cmake_jump_on_error=0
Plug 'cdelledonne/vim-cmake'
nnoremap <silent> <Leader>c :CMakeBuild<cr>

function! OnCompileError()
  CMakeClose
  copen
endfunction

function! OnCompileOk()
  CMakeClose
  cclose
  call asyncrun#run("!",
        \ {
        \ 'mode': 'term',
        \ 'pos': 'right',
        \ 'focus': 0,
        \ 'raw': 1,
        \ 'cwd': asyncrun#get_root(getcwd())
        \ },
        \ "bash .localrun")
endfunction

augroup vim-cmake-group
autocmd User CMakeBuildFailed call OnCompileError()
augroup END

augroup vim-cmake-group
autocmd! User CMakeBuildSucceeded call OnCompileOk()
augroup END

" =============================================================================
" Syntax highlighter
" =============================================================================
Plug 'sheerun/vim-polyglot'

" =============================================================================
" Insert mode auto-completion for quotes, parens, brackets
" =============================================================================
Plug 'Raimondi/delimitMate'

" =============================================================================
" Code-completion LSP
" =============================================================================
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" =============================================================================
" Better iTerm2 integration
" =============================================================================
Plug 'sjl/vitality.vim'

" =============================================================================
" Fix * in visual mode
" =============================================================================
Plug 'nelstrom/vim-visual-star-search'

" =============================================================================
" Search in files
" =============================================================================
let g:ctrlsf_regex_pattern = 1
let g:ctrlsf_auto_close = {
    \ "normal" : 0,
    \ "compact": 0
    \}
let g:ctrlsf_position = 'left'
Plug 'dyng/ctrlsf.vim'
noremap <leader>s  :CtrlSF<space>

Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" =============================================================================
" Surround
" =============================================================================
Plug 'tpope/vim-surround'

" =============================================================================
" Search
" =============================================================================
let g:fzf_layout = { 'down': '15' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
nnoremap <Leader><space> :Ag<cr>
nnoremap <C-P> :Files<cr>

let g:ack_use_cword_for_empty_search = 1
cnoreabbrev Ack Ack!
Plug 'mileszs/ack.vim'
nnoremap <Leader>/ :Ack!<Space>
nnoremap <Leader>* :Ack!<cr>

" =============================================================================
" Tmux
" =============================================================================
let g:tmux_navigator_no_mappings = 1
Plug 'christoomey/vim-tmux-navigator'

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

if executable('tmux') && filereadable(expand('~/.zshrc')) && $TMUX !=# ''
  let g:vimIsInTmux = 1
else
  let g:vimIsInTmux = 0
endif

if g:vimIsInTmux == 1
  let g:tmuxline_preset = 'powerline'
  autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%"))
  autocmd VimLeave * call system("tmux rename-window zsh")
  set ttymouse=xterm2
  set mouse=a
endif

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" =============================================================================
" Colors
" =============================================================================
Plug 'kooparse/vim-color-desert-night'
Plug 'edkolev/tmuxline.vim'

" =============================================================================
" End Plugins
" =============================================================================
call plug#end()

" =============================================================================
" 24bit colors
" =============================================================================
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" =============================================================================
" Colorscheme
" =============================================================================
set background=dark
colorscheme desert-night
hi Normal guifg=#d4b07b guibg=#24221c guisp=NONE gui=NONE cterm=NONE
hi Terminal guifg=#d4b07b guibg=#24221c guisp=NONE gui=NONE cterm=NONE
hi VertSplit guifg=#473f31 guibg=#24221c guisp=NONE gui=NONE cterm=NONE

let g:lightline = {'colorscheme' : 'desert_night'}
" Disable italics
" hi VisualNOS gui=NONE cterm=NONE
" hi Comment gui=NONE cterm=NONE
" hi SpecialComment gui=NONE cterm=NONE
" hi markdownItalic gui=NONE cterm=NONE
" hi htmlItalic gui=NONE cterm=NONE
