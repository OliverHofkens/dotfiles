" Python plugin system
let g:python3_host_prog = expand('~/.local/share/virtualenvs/nvim-python-env-sjxtMNZd/bin/python')

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

" Window management
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" Signify
let g:signify_vcs_list=['git']
let g:signify_sign_change = "~"

" NERDTree & related:
map <C-b> :NERDTreeToggle<CR>

let g:NERDTreeLimitedSyntax = 1  " PERF: Don't highlight uncommon filetypes.
let g:NERDTreeShowHidden=1         " Show hidden files
let g:NERDTreeQuitOnOpen = 1       " Quit after opening a file 
let g:NERDTreeIgnore = ['^.DS_Store$', '^__pycache__$']

" Search
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-i': 'split',
  \ 'ctrl-s': 'vsplit' }
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

nnoremap <c-p> :Files<cr>

" Syntax
let g:python_highlight_all = 1

" Language extras
" Completions already handled by deoplete
let g:jedi#completions_enabled = 0
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#use_splits_not_buffers = "winwidth"

" Comments
let g:NERDDefaultAlign = 'left'
let g:NERDToggleCheckAllLines = 1

" Autocomplete
let g:deoplete#enable_at_startup=1
call deoplete#custom#option('auto_complete_delay', 200)

" Linting
let g:ale_completion_enabled=0
let g:ale_fix_on_save=1
let g:ale_linters={'rust': ['rls']}
let g:ale_fixers={
\ 'python': [
\	'black',
\	'isort'
\ ],
\ 'rust': ['rustfmt'],
\ 'json': ['jq'],
\ 'javascript': [
\       'prettier', 
\       'eslint'
\ ],
\ 'vue': [
\       'prettier', 
\       'eslint'
\ ]
\}
let g:ale_python_black_executable = expand("~/.local/share/virtualenvs/nvim-python-env-sjxtMNZd/bin/black")
let g:ale_python_isort_executable = expand("~/.local/share/virtualenvs/nvim-python-env-sjxtMNZd/bin/isort")
let g:ale_python_flake8_executable = expand("~/.local/share/virtualenvs/nvim-python-env-sjxtMNZd/bin/flake8")
let g:ale_python_mypy_executable = expand("~/.local/share/virtualenvs/nvim-python-env-sjxtMNZd/bin/mypy")
let g:ale_yaml_yamllint_executable = expand("~/.local/share/virtualenvs/nvim-python-env-sjxtMNZd/bin/yamllint")

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
let g:afterglow_inherit_background = 1
colorscheme afterglow
