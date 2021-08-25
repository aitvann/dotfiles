call plug#begin('~/.vim/plugged')
" general
" delete the buffer without closing the window
Plug 'qpkorr/vim-bufkill'
" interactive git
Plug 'tpope/vim-fugitive'
" shows signs for added, modified, and removed lines.
Plug 'mhinz/vim-signify'
" smooth scrolling
Plug 'yuttie/comfortable-motion.vim'
" integrates vs code pluggins to vim, was used for LSP, now use native
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" interface
Plug 'mhinz/vim-startify'
" status bar
Plug 'itchyny/lightline.vim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'mengelbrecht/lightline-bufferline'
" open file with ranger window
Plug 'kevinhwang91/rnvimr'
" fzf integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" status bar, use lightline instead it's faster, minimalistic and easily configurable
" Plug 'vim-airline/vim-airline'
" tree file browser, use ranger instead
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" checks for syntax and shows errors, use LS instead
" Plug 'scrooloose/syntastic'
" fuzzy file searcher, use FZF instead
" Plug 'kien/ctrlp.vim'

" editing
" automaticaly close ", (, {, etc.
Plug 'jiangmiao/auto-pairs'
" easily change the sorrounding
Plug 'tpope/vim-surround'
" jump over the file
Plug 'easymotion/vim-easymotion'
" gc to comment line
Plug 'tpope/vim-commentary'
" formating using other formaters
Plug 'sbdchd/neoformat'

" lsp
" the bridge between lua and configuration of LS
Plug 'neovim/nvim-lspconfig'
" enable extra features from LS (inline hints for Rust)
Plug 'nvim-lua/lsp_extensions.nvim'
" autocompletion using LSP
Plug 'nvim-lua/completion-nvim'
Plug 'gfanto/fzf-lsp.nvim'

" colorschemes
Plug 'jdkanani/vim-material-theme'
Plug 'kaicataldo/material.vim'
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'

" langs
Plug 'cespare/vim-toml'
" Plug 'rust-lang/rust.vim'

call plug#end()

