set hidden
set nowrap
set signcolumn=yes
set showtabline=2
set number relativenumber
" set cursorline cursorcolumn

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
" to the right
nmap <C-R> <C-W>L

" leader
let mapleader = "'"
nmap <silent> <leader>;     :call OpenTerminal()<CR>
nmap          <leader>o     o<Esc>
nmap          <leader>O     O<Esc>

