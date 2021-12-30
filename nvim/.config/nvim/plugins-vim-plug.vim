call plug#begin('~/.nvim/plugins')



" --------------------------------------------------------------------------------
" General
" --------------------------------------------------------------------------------

" delete the buffer without closing the window
Plug 'qpkorr/vim-bufkill'

" interactive git
Plug 'tpope/vim-fugitive'

" smooth scrolling
Plug 'karb94/neoscroll.nvim'

" jump over the file
Plug 'easymotion/vim-easymotion'

" highlight color code
Plug 'norcalli/nvim-colorizer.lua'

" sugar for lua mapping
Plug 'b0o/mapx.nvim'

" useful lua functions
Plug 'nvim-lua/plenary.nvim'

" analyze file structure
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" integrates vs code pluggins to vim, was used for LSP, now use native
" Plug 'neoclide/coc.nvim', {'branch': 'release'}



" --------------------------------------------------------------------------------
" Interface
" --------------------------------------------------------------------------------

" start screen
Plug 'mhinz/vim-startify'

" shows signs for added, modified, and removed lines.
Plug 'mhinz/vim-signify'

" status bar
Plug 'itchyny/lightline.vim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'mengelbrecht/lightline-bufferline'

" open file with ranger window
Plug 'kevinhwang91/rnvimr'

" fuzzy finder over lists
Plug 'nvim-telescope/telescope.nvim'
Plug 'xiyaowong/telescope-emoji.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" better renaming input
Plug 'filipdutescu/renamer.nvim', { 'branch': 'master' }

" status bar, use lightline instead it's faster, minimalistic and easily configurable
" Plug 'vim-airline/vim-airline'

" tree file browser, use ranger instead
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" checks for syntax and shows errors, use LS instead
" Plug 'scrooloose/syntastic'

" fuzzy file searcher, use FZF instead
" Plug 'kien/ctrlp.vim'



" --------------------------------------------------------------------------------
" Editing
" --------------------------------------------------------------------------------

" automaticaly close ", (, {, etc.
Plug 'jiangmiao/auto-pairs'

" easily change the sorrounding
Plug 'tpope/vim-surround'

" gc to comment line
Plug 'tpope/vim-commentary'

" formating using multiple formaters
Plug 'sbdchd/neoformat'

" autocomplition using multiple sources
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-path'

" snippets (required by `nvim-cmp`)
Plug 'hrsh7th/vim-vsnip'



" --------------------------------------------------------------------------------
" Lsp
" --------------------------------------------------------------------------------

" the bridge between lua and configuration of LS
Plug 'neovim/nvim-lspconfig'

" enable extra features from LS (inline hints for Rust)
Plug 'nvim-lua/lsp_extensions.nvim'

" source for complitions using LSP
Plug 'hrsh7th/cmp-nvim-lsp'

" bridge between language tools that don't speak LSP and the LSP ecosystem
Plug 'jose-elias-alvarez/null-ls.nvim'



" --------------------------------------------------------------------------------
" Colorschemes
" --------------------------------------------------------------------------------

Plug 'jdkanani/vim-material-theme'
Plug 'kaicataldo/material.vim'
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'rebelot/kanagawa.nvim'



" --------------------------------------------------------------------------------
" Langs
" --------------------------------------------------------------------------------

Plug 'cespare/vim-toml'
" Plug 'rust-lang/rust.vim'



call plug#end()

