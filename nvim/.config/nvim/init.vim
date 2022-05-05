" For documentation files, enable text wrapping and spell checking
augroup docs_config
  autocmd!
  autocmd BufRead,BufNewFile *.md,*.rst setlocal textwidth=80 spell spelllang=en
augroup END

" Window management
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" General
syntax on
filetype plugin on

let mapleader=" "

set splitbelow
set splitright

set number relativenumber	" Show hyrbid line numbers
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


call plug#begin(stdpath('data') . '/plugged')

" General
Plug 'nvim-lua/plenary.nvim'
Plug 'tpope/vim-sensible'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'Yggdroot/indentLine'
Plug 'nvim-lualine/lualine.nvim'
Plug 'takac/vim-hardtime'

" Search
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" VCS
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

" Syntax and language extras
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" File browser
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'

" Theme
Plug 'danilo-augusto/vim-afterglow'

call plug#end()			" Init plugin system

lua require("cfg")

" HardTime
let g:hardtime_default_on = 1
let g:hardtime_showmsg = 1
let g:hardtime_ignore_buffer_patterns = [ "NERD.*" ]
let g:hardtime_ignore_quickfix = 1
let g:hardtime_maxcount = 2
let g:hardtime_allow_different_key = 1

" NERDTree & related:
map <C-b> :NERDTreeToggle<CR>

let g:NERDTreeLimitedSyntax = 1  " PERF: Don't highlight uncommon filetypes.
let g:NERDTreeShowHidden=1         " Show hidden files
let g:NERDTreeQuitOnOpen = 1       " Quit after opening a file
let g:NERDTreeIgnore = ['^.DS_Store$', '^__pycache__$']

" Comments
let g:NERDDefaultAlign = 'left'
let g:NERDToggleCheckAllLines = 1

" Theme
let g:afterglow_inherit_background = 1
colorscheme afterglow
