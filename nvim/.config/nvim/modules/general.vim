set hidden
set autoread
set nowrap
set signcolumn=yes
set number relativenumber
set updatetime=1000
set encoding=utf-8
set noshowmode
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
" move block of code
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

" leader
let mapleader = "'"
nmap          <leader>o     o<Esc>
nmap          <leader>O     O<Esc>

