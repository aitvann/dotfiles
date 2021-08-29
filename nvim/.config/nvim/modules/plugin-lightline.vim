let g:lightline = { 'colorscheme': 'tokyonight' }
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

augroup fmt
    autocmd!
    autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
augroup END

