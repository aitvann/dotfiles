call plug#begin('~/.nvim/plugins')



" --------------------------------------------------------------------------------
" General
" --------------------------------------------------------------------------------

" delete the buffer without closing the window
Plug 'moll/vim-bbye'

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



" --------------------------------------------------------------------------------
" Interface
" --------------------------------------------------------------------------------

" start screen
Plug 'mhinz/vim-startify'

" status line
Plug 'nvim-lualine/lualine.nvim'

" open file with ranger window
Plug 'kevinhwang91/rnvimr'

" fuzzy finder over lists
Plug 'nvim-telescope/telescope.nvim'
Plug 'xiyaowong/telescope-emoji.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" better renaming input
Plug 'filipdutescu/renamer.nvim', { 'branch': 'master' }

" better signature help
Plug 'ray-x/lsp_signature.nvim'

" Magit for neovim
Plug 'TimUntersberger/neogit'

" diff tab
Plug 'sindrets/diffview.nvim'

" shows signs for added, modified, and removed lines.
" and other git stuff inside buffer
Plug 'lewis6991/gitsigns.nvim'

" opens a popup with suggestions to complete a key binding
Plug 'folke/which-key.nvim'



" --------------------------------------------------------------------------------
" Editing
" --------------------------------------------------------------------------------

" automaticaly close ", (, {, etc.
Plug 'windwp/nvim-autopairs'

" easily change the sorrounding
Plug 'tpope/vim-surround'

" gc to comment line
Plug 'numToStr/Comment.nvim'
" context aware commenting
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

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

" get progress state and messages from LSP
Plug 'nvim-lua/lsp-status.nvim'



" --------------------------------------------------------------------------------
" Colorschemes
" --------------------------------------------------------------------------------

Plug 'rktjmp/lush.nvim'
Plug 'jdkanani/vim-material-theme'
Plug 'kaicataldo/material.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'rebelot/kanagawa.nvim'
Plug 'EdenEast/nightfox.nvim'
Plug 'ellisonleao/gruvbox.nvim'



" --------------------------------------------------------------------------------
" Langs
" --------------------------------------------------------------------------------

Plug 'cespare/vim-toml'



call plug#end()

