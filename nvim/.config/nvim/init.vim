" Python plugin system
let g:python3_host_prog='/Users/oliver/.local/share/virtualenvs/.python-nvim-venv---J-hpZ7/bin/python'

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
call plug#begin(stdpath('data') . '/plugged')
" General
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'Yggdroot/indentLine'
Plug 'vim-airline/vim-airline'
" Search
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
" VCS
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
" Syntax and language extras
Plug 'vim-python/python-syntax'
Plug 'rust-lang/rust.vim'
Plug 'davidhalter/jedi-vim'
" Linting
Plug 'dense-analysis/ale'
" Autocomplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
" File browser
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
" Theme
Plug 'danilo-augusto/vim-afterglow'
call plug#end()			" Init plugin system

" Signify
let g:signify_sign_change = "~"

" NERDTree & related:
map <C-b> :NERDTreeToggle<CR>

let g:NERDTreeLimitedSyntax = 1  " PERF: Don't highlight uncommon filetypes.
let NERDTreeShowHidden=1         " Show hidden files

" Syntax
let g:python_highlight_all = 1

" Language extras
" Completions already handled by deoplete
let g:jedi#completions_enabled = 0
let g:jedi#use_tabs_not_buffers = 0

" Autocomplete
let g:deoplete#enable_at_startup=1

" Linting
let g:ale_completion_enabled=1
let g:ale_fix_on_save=1
let g:ale_python_auto_pipenv=1
let g:ale_linters={'rust': ['rls']}
let g:ale_fixers={
\ 'python': [
\	'black',
\	'isort'
\ ],
\ 'rust': ['rustfmt'],
\}

" General
syntax on
filetype plugin on

let mapleader=" "

set number			" Show line numbers
set linebreak			" Break lines at word (requires Wrap lines)
set showbreak=+++		" Wrap-broken line prefix
set colorcolumn=80              " Visual ruler
set showmatch			" Highlight matching brace
set visualbell			" Use visual bell (no beeping)

set hlsearch			" Highlight all search results
set smartcase			" Enable smart-case search
set ignorecase			" Always case-insensitive
set incsearch			" Searches for strings incrementally

set autoindent			" Auto-indent new lines
set shiftwidth=4		" Number of auto-indent spaces
set smartindent			" Enable smart-indent
set smarttab			" Enable smart-tabs
set softtabstop=4		" Number of spaces per Tab
set expandtab

set ruler			" Show row and column ruler information

set undolevels=1000		" Number of undo levels
set backspace=indent,eol,start	" Backspace behaviour

" Theme
colorscheme afterglow
let g:afterglow_blackout=1
