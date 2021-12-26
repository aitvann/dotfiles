set hidden
set autoread
set nowrap
set signcolumn=yes
set showtabline=2
set number relativenumber
set scrolloff=10
set updatetime=1000
" set cursorline cursorcolumn

if (has('termguicolors'))
    set termguicolors
endif

syntax enable
filetype plugin indent on

" tab
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" search
set hlsearch
set incsearch
nmap <silent> <C-H> :noh<CR>

" mappings
imap jj <Esc>
nmap Y y$
nmap U :redo<CR>
nmap <silent> <Del> :q<CR>
xmap > >gv
xmap < <gv
" to the right
nmap <C-R> <C-W>L

" leader
let mapleader = "'"
nmap          <leader>o     o<Esc>
nmap          <leader>O     O<Esc>

