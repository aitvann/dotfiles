nmap <silent> <Backspace>   :call DeleteBuffer()<CR>
nmap <silent> <leader>;     :call OpenTerminal()<CR>

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

