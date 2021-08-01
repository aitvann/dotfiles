" plugins
call plug#begin('~/.vim/plugged')
" general
" integrates vs code pluggins to vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" delete the buffer without closing the window
Plug 'qpkorr/vim-bufkill'
" interactive git
Plug 'tpope/vim-fugitive'
" shows signs for added, modified, and removed lines.
Plug 'airblade/vim-gitgutter'

" interface
" status bar
Plug 'vim-airline/vim-airline'
" open file with ranger window
Plug 'kevinhwang91/rnvimr'
" tree file browser, use ranger instead
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" checks for syntax and shows errors, use LS instead
" Plug 'scrooloose/syntastic'
" fuzzy file searcher, use fzf instead
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

" colorschemes
Plug 'jdkanani/vim-material-theme'
Plug 'kaicataldo/material.vim'
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'

" langs
" Plug 'rust-lang/rust.vim'

call plug#end()


" general
set hidden
set relativenumber
set nowrap
syntax on

"tab
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" search
set hlsearch
set incsearch

" colorscheme
colorscheme gruvbox
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:gruvbox_contrast_dark = 'medium'
set bg=dark

" title-bar
let g:airline_left_sep=''
let g:airline_right_sep=''

" ranger
let g:rnvimr_enable_picker = 1


" mappings
" let g:mapleader=','
imap jj <Esc> 
nmap U :redo<CR>

" mappings-windows
" map <C-Q> :q<CR>
" map <C-O> <C-W>o
" to the right
map <C-R> <C-W>L
" moving around
nmap <silent> gh :call WinMove('h')<CR>
nmap <silent> gj :call WinMove('j')<CR>
nmap <silent> gk :call WinMove('k')<CR>
nmap <silent> gl :call WinMove('l')<CR>
" moving(swapping) current window
map gsh <C-H> <C-W>x
map gsj <C-J> <C-W>x
map gsk <C-K> <C-W>x
map gsl <C-L> <C-W>x
" resizing
map <silent> <S-Left> :vertical resize -1<CR>
map <silent> <S-Down> :resize +1<CR>
map <silent> <S-Up> :resize -1<CR>
map <silent> <S-Right> :vertical resize +1<CR>
" scrolling
map <silent> <Left> zh
map <silent> <Down> <C-E>
map <silent> <Up> <C-Y>
map <silent> <Right> zl
" opening
nmap <silent> '' <C-W>v
nmap <silent> 't :call OpenTerminal()<CR>
nmap <silent> 'r :RnvimrToggle<CR>

" mappings-buffers
nmap <silent> <Tab> :bnext<CR>
nmap <silent> <S-Tab> :bprevious<CR>
nmap <silent> <Backspace> :call DeleteBuffer()<CR>

" mappings-nerdtree
" map gn :NERDTreeToggle<CR>

" mappings-easymotion
" map <Leader> <Plug>(easymotion-prefix)
map , <Plug>(easymotion-bd-f)
nmap , <Plug>(easymotion-overwin-f)

" mappings-ctrlp
" let g:ctrlp_map = 'gp'


" command! -nargs=? OpenTerminal execute 'terminal <args>' | let b:is_term = 1 | execute 'startinsert'

function! OpenTerminal()
    execute 'terminal'
    let b:is_term = 1 
    execute 'startinsert'
    tmap <buffer> jj <C-\><C-N>
endfunction

function! DeleteBuffer()
    if (get(b:, 'is_term', 0) == 1)
        exec "BD!"
    else
        exec "BD"
    endif
endfunction

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

if (has('termguicolors'))
  set termguicolors
endif
