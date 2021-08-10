" plugins
call plug#begin('~/.vim/plugged')
" general
" delete the buffer without closing the window
Plug 'qpkorr/vim-bufkill'
" interactive git
Plug 'tpope/vim-fugitive'
" shows signs for added, modified, and removed lines.
Plug 'mhinz/vim-signify'
" integrates vs code pluggins to vim, was used for LSP, now use native
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" interface
" status bar
Plug 'itchyny/lightline.vim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'mengelbrecht/lightline-bufferline'
" open file with ranger window
Plug 'kevinhwang91/rnvimr'
" fzf integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" select file using ranger when open folder
Plug 'iberianpig/ranger-explorer.vim'
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


" general
set hidden
set number relativenumber
set nu rnu
set nowrap
syntax enable
filetype plugin indent on
set signcolumn=yes
set showtabline=2
imap jj <Esc>
nmap Y y$
nmap U :redo<CR>
nnoremap ]o o<Esc>
nnoremap [o O<Esc>
" set cursorline cursorcolumn

" leader key
let mapleader = "'"
nmap <silent> <leader><leader> :call OpenTerminal()<CR>
nmap <silent> <leader>e        :RnvimrToggle<CR>
nmap <silent> <leader>a        :CodeActions<CR>
nmap <silent> <leader>M        :Diagnostics<CR>
nmap          <leader>m        <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nmap          <leader>i        <cmd>lua vim.lsp.buf.hover()<CR>
nmap          <leader>r        <cmd>lua vim.lsp.buf.rename()<CR>

" tab
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" search
set hlsearch
set incsearch
nmap <silent> <C-H> :noh<CR>

" windows
nmap <silent> <Del> :q<CR>
" to the right
map <C-R> <C-W>L
" resizing
nmap <silent> <S-Left> :vertical resize -4<CR>
nmap <silent> <S-Down> :resize +4<CR>
nmap <silent> <S-Up> :resize -4<CR>
nmap <silent> <S-Right> :vertical resize +4<CR>
" scrolling
map <silent> <Left> zh
map <silent> <Down> 4<C-E>
map <silent> <Up> 4<C-Y>
map <silent> <Right> zl


" buffers
nmap <silent> <Tab> :bnext<CR>
nmap <silent> <S-Tab> :bprevious<CR>
nmap <silent> <Backspace> :call DeleteBuffer()<CR>

function! OpenTerminal()
    execute 'terminal'
    let b:is_term = 1 
    execute 'startinsert'
    tmap <buffer> <Esc> <C-\><C-N>
endfunction

function! DeleteBuffer()
    if (get(b:, 'is_term', 0) == 1)
        exec "BD!"
    else
        exec "BD"
    endif
endfunction


" moving around
nmap <silent> gw :Lines<CR>
nmap <silent> gW :Rg<CR>
nmap <silent> gf :Files<CR>
nmap <silent> gb :Buffers<CR>
nmap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nmap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nmap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nmap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nmap <silent> gs <cmd>lua vim.lsp.buf.document_symbol()<CR>
nmap <silent> gS <cmd>lua vim.lsp.buf.workspace_symbol()<CR><CR>
" moving over the windows
nmap <silent> gh :call WinMove('h')<CR>
nmap <silent> gj :call WinMove('j')<CR>
nmap <silent> gk :call WinMove('k')<CR>
nmap <silent> gl :call WinMove('l')<CR>
" moving(swapping) current window
map gsh <C-W>h <C-W>x
map gsj <C-W>j <C-W>x
map gsk <C-W>k <C-W>x
map gsl <C-W>l <C-W>x

function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key, '[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction


" colorscheme
colorscheme gruvbox
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:gruvbox_contrast_dark = 'medium'
set bg=dark

if (has('termguicolors'))
    set termguicolors
endif


" status-bar
let g:lightline = { 'colorscheme': 'gruvbox' }
let g:lightline.component = {
    \ 'buffers-section': 'buffers' }
let g:lightline.component_function = {
    \ 'gitstatus': 'GitStatus',
    \ 'gitbranch': 'FugitiveHead',
    \ 'lsp': 'LspStatus' }
let g:lightline.component_expand = {
    \ 'buffers': 'lightline#bufferline#buffers' }
let g:lightline.component_type = {
    \ 'buffers': 'tabsel' }
let g:lightline.tabline = {
    \ 'left': [ [ 'buffers' ] ],
    \ 'right': [ [ 'buffers-section' ] ] }
let g:lightline.active = {
    \ 'left': [ [ 'mode' ],
    \           [ 'gitbranch', 'gitstatus' ] ],
    \ 'right': [ [ 'lsp' ],
    \            [ 'percent', 'lineinfo' ],
    \            [ 'fileformat', 'fileencoding', 'filetype' ] ] }
let g:lightline.inactive = {
    \ 'left': [ [ 'filename' ] ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ] ] }
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }
let g:lightline.tabline_separator = { 'left': '', 'right': '' }
let g:lightline.tabline_subseparator = { 'left': '│', 'right': '│' }
let g:lightline#bufferline#shorten_path = 0

function! GitStatus()
    let l:res = []

    let [added, modified, removed] = sy#repo#get_stats()
    if (added > 0)
        call add(l:res, printf('+%d', added))
    endif
    if (modified > 0)
        call add(l:res, printf('~%d', modified))
    endif
    if (removed > 0)
        call add(l:res, printf('-%d', removed))
    endif

    return join(l:res, ' ')
endfunction

function! LspStatus() abort
    if luaeval('#vim.lsp.buf_get_clients() > 0')
        return luaeval("require('lsp-status').status()")[6:-2]
    endif

    return 'Ok'
endfunction

autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()

" let g:airline_left_sep=''
" let g:airline_right_sep=''
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#show_buffers = 1


" ranger
let g:rnvimr_enable_picker = 1

"fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'

" auto-completion
set completeopt=menuone,noinsert,noselect
imap <silent> <C-Space> <Plug>(completion_trigger)

" easymotion
map , <Plug>(easymotion-bd-f)
nmap , <Plug>(easymotion-overwin-f)

" formating
augroup fmt
  autocmd!
  autocmd BufWritePre * Neoformat
augroup END


" VCS
nmap } <plug>(signify-next-hunk)zz
nmap { <plug>(signify-prev-hunk)zz

omap ih <plug>(signify-motion-inner-pending)
xmap ih <plug>(signify-motion-inner-visual)
omap ah <plug>(signify-motion-outer-pending)
xmap ah <plug>(signify-motion-outer-visual)

autocmd User SignifyHunk call ShowCurrentHunk()

function! ShowCurrentHunk() abort
    let h = sy#util#get_hunk_stats()
    if !empty(h)
        echo printf('[Hunk %d/%d]', h.current_hunk, h.total_hunks)
    endif
endfunction


" disable autocomment by default
let b:autocomment = 0
autocmd BufNewFile,BufRead * :DisableAutoComment

command! EnableAutoComment :set formatoptions+=cro | :let b:autocomment = 1
command! DisableAutoComment :set formatoptions-=cro | :let b:autocomment = 0
command! ToggleAutoComment call ToggleAutoComment()

function! ToggleAutoComment()
    if (b:autocomment)
        :DisableAutoComment
    else
        :EnableAutoComment
    endif
endfunction


" ctrlp
" let g:ctrlp_map = 'gp'

" mappings-nerdtree
" map gn :NERDTreeToggle<CR>


luafile $HOME/.config/nvim/lsp-config.lua


" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = 'ᐅ ', highlight = "Comment", enabled = {"ChainingHint"} }

