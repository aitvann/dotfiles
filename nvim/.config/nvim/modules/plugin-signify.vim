nmap } <plug>(signify-next-hunk)zz
nmap { <plug>(signify-prev-hunk)zz

omap ih <plug>(signify-motion-inner-pending)
xmap ih <plug>(signify-motion-inner-visual)
omap ah <plug>(signify-motion-outer-pending)
xmap ah <plug>(signify-motion-outer-visual)

augroup hunk
    autocmd!
    autocmd User SignifyHunk call ShowCurrentHunk()
augroup END

function! ShowCurrentHunk() abort
    let h = sy#util#get_hunk_stats()
    if !empty(h)
        echo printf('[Hunk %d/%d]', h.current_hunk, h.total_hunks)
    endif
endfunction

