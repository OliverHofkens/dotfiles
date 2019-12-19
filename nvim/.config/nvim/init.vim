" Python plugin system
let g:python3_host_prog='/Users/oliver/.local/share/virtualenvs/.python-nvim-venv---J-hpZ7/bin/python'

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
call plug#begin(stdpath('data') . '/plugged')
" General
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'
" Search
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
" VCS
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
" Syntax
Plug 'vim-python/python-syntax'
" Linting and autocomplete
Plug 'dense-analysis/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" File browser
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Theme
Plug 'danilo-augusto/vim-afterglow'
call plug#end()			" Init plugin system

" NERDTree & related:
map <C-b> :NERDTreeToggle<CR>

let g:NERDTreeLimitedSyntax = 1  " PERF: Don't highlight uncommon filetypes.
let NERDTreeShowHidden=1         " Show hidden files

" Syntax
let g:python_highlight_all = 1

" Autocomplete
let g:deoplete#enable_at_startup=1

" Linting
let g:ale_completion_enabled=1
let g:ale_fix_on_save=1
let g:ale_python_auto_pipenv=1
let g:ale_fixers={
\ 'python': [
\       'remove_trailing_lines',
\	'black',
\	'isort'
\ ],
\ 'rust': ['rustfmt'],
\}

" General
syntax on
filetype plugin on

set number			" Show line numbers
set linebreak			" Break lines at word (requires Wrap lines)
set showbreak=+++		" Wrap-broken line prefix
set textwidth=80		" Line wrap (number of cols)
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

set ruler			" Show row and column ruler information

set undolevels=1000		" Number of undo levels
set backspace=indent,eol,start	" Backspace behaviour

" Theme
colorscheme afterglow
let g:afterglow_blackout=1
