let b:autocomment = 0

nmap <leader>c :ToggleAutoComment<CR>

augroup autocomment
    autocmd!
    autocmd BufNewFile,BufRead * :DisableAutoComment
augroup END

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

