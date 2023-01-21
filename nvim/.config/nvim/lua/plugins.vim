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

" useful lua functions
Plug 'nvim-lua/plenary.nvim'

" analyze file structure
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" easily create textobjects
Plug 'kana/vim-textobj-user'

" Sudo write
Plug 'lambdalisue/suda.vim'



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

" Show treesetter oputput, make queries 
Plug 'nvim-treesitter/playground'

" Pretty icons
Plug 'nvim-tree/nvim-web-devicons'

" Pretty telescope select menu
Plug 'nvim-telescope/telescope-ui-select.nvim'

" Show code context at window top
Plug 'nvim-treesitter/nvim-treesitter-context'



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

" v text object to select bar in foo_ba|r_bax
Plug 'Julian/vim-textobj-variable-segment'

" Highlights parentheses in rainbo
Plug 'mrjones2014/nvim-ts-rainbow'




" --------------------------------------------------------------------------------
" Lsp
" --------------------------------------------------------------------------------

" the bridge between lua and configuration of LS
Plug 'neovim/nvim-lspconfig'

" source for complitions using LSP
Plug 'hrsh7th/cmp-nvim-lsp'

" bridge between language tools that don't speak LSP and the LSP ecosystem
Plug 'jose-elias-alvarez/null-ls.nvim'

" enable inlay hints (inlay type hints for Rust)
Plug 'simrat39/inlay-hints.nvim'

" get progress state and messages from LSP
Plug 'nvim-lua/lsp-status.nvim'

" SQl lsp
Plug 'nanotee/sqls.nvim'

" For pretty kind icons on completion
Plug 'onsails/lspkind.nvim'



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



call plug#end()

