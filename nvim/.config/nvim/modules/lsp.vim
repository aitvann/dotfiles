luafile ~/.config/nvim/modules/lsp.lua

" mappings
nmap gr         <cmd>lua vim.lsp.buf.references()<CR>
nmap gd         <cmd>lua vim.lsp.buf.definition()<CR>
nmap gD         <cmd>lua vim.lsp.buf.declaration()<CR>
nmap gi         <cmd>lua vim.lsp.buf.implementation()<CR>
nmap gs         <cmd>lua vim.lsp.buf.document_symbol()<CR>
nmap gS         <cmd>lua vim.lsp.buf.workspace_symbol()<CR><CR>
nmap <leader>a  <cmd>lua vim.lsp.buf.code_action()<CR>
nmap <leader>M  <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nmap <leader>m  <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nmap <leader>i  <cmd>lua vim.lsp.buf.hover()<CR>
nmap <leader>r  <cmd>lua vim.lsp.buf.rename()<CR>

" Enable type inlay hints
augroup hints
    autocmd!
    autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
    \ lua require'lsp_extensions'.inlay_hints{ prefix = 'ᐅ ', highlight = "Comment", enabled = {"ChainingHint"} }
augroup END

