let g:lightline = { 'colorscheme': 'tokyonight' }
let g:lightline.component = {
    \ 'buffers-section': 'buffers' }
let g:lightline.component_function = {
    \ 'gitbranch': 'FugitiveHead',
    \ 'lsp': 'LspStatus' }
let g:lightline.component_expand = {
    \ 'buffers': 'lightline#bufferline#buffers' }
let g:lightline.component_type = {
    \ 'buffers': 'tabsel' }
let g:lightline.active = {
    \ 'left': [ [ 'mode' ],
    \           [ 'gitbranch'] ],
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

function! LspStatus() abort
    if luaeval('#vim.lsp.buf_get_clients() > 0')
        return luaeval("require('lsp-status').status()")[6:-2]
    endif

    return 'No Lsp'
endfunction

augroup fmt
    autocmd!
    autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
augroup END

