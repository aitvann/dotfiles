" resizing
nnoremap <silent> <S-Left> :call ResizeLeft(4)<cr>
nnoremap <silent> <S-Down> :call ResizeDown(4)<cr>
nnoremap <silent> <S-Up> :call ResizeUp(4)<cr>
nnoremap <silent> <S-Right> :call ResizeRight(4)<cr>

" scrolling
map <silent> <Left> zh
map <silent> <Down> L:call comfortable_motion#flick(40)<CR>
map <silent> <Up> H:call comfortable_motion#flick(-40)<CR>
map <silent> <Right> zl
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

