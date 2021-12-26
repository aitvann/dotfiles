local lsp = require 'lspconfig'
local cmp = require 'cmp_nvim_lsp'
local status = require 'lsp-status'
local mapx = require 'mapx'
mapx.setup{ global = 'force' }

-- compose `to_attach` functions from all pluggins
local on_attach = function(client)
    status.on_attach(client)

    -- mappings
    nnoremap("gr",          "<cmd> lua require'telescope.builtin'.lsp_references()          <CR>", "silent")
    nnoremap("gd",          "<cmd> lua require'telescope.builtin'.lsp_definitions()         <CR>", "silent")
    nnoremap("gt",          "<cmd> lua require'telescope.builtin'.lsp_type_definitions()    <CR>", "silent")
    nnoremap("gi",          "<cmd> lua require'telescope.builtin'.lsp_implementations()     <CR>", "silent")
    nnoremap("gs",          "<cmd> lua require'telescope.builtin'.lsp_document_symbols()    <CR>", "silent")
    nnoremap("gS",          "<cmd> lua require'telescope.builtin'.lsp_workspace_symbols()   <CR>", "silent")
    nnoremap("<leader>M",   "<cmd> lua require'telescope.builtin'.diagnostics()             <CR>", "silent")
    nnoremap("<leader>m",   "<cmd> lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })<CR>", "silent")
    nnoremap("<leader>a",   "<cmd> lua require'telescope.builtin'.lsp_code_actions(require'telescope.themes'.get_cursor())<CR>", "silent")
    nnoremap("<leader>i",   "<cmd> lua vim.lsp.buf.hover({ focusable = false }) <CR>", "silent")
    nnoremap("<leader>r",   "<cmd> lua vim.lsp.buf.rename()                     <CR>", "silent")

    -- hover highlighting
    if client.resolved_capabilities.document_highlight then
        vim.cmd [[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]]
    end

    -- inline type hints
    vim.cmd [[
        highlight LspReferenceRead  guibg=#3a405e
        highlight LspReferenceText  guibg=#3a405e
        highlight LspReferenceWrite guibg=#3a405e

        augroup inline_type_hints
            autocmd! * <buffer>
            autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost <buffer>
            \ lua require'lsp_extensions'.inlay_hints{ prefix = 'ᐅ ', highlight = "Comment", enabled = {"ChainingHint"} }
        augroup END
    ]]

    -- diagnostics in line number
    vim.cmd [[
        highlight DiagnosticLineNrError   guifg=#FF0000 gui=bold
        highlight DiagnosticLineNrWarn    guifg=#FFA500 gui=bold
        highlight DiagnosticLineNrInfo    guifg=#00AA00 gui=bold
        highlight DiagnosticLineNrHint    guifg=#CCCCCC gui=bold

        sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
        sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
        sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
        sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
    ]]
end

-- construct capabilities object
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp.update_capabilities(capabilities) -- update capabilities from 'cmp_nvim_lsp` plugin
capabilities = vim.tbl_extend('keep', capabilities, status.capabilities) -- update capabilities from `lsp-status` plugin

-- tries to load settings or return empty
local function load_settings(server)
    local res, module = pcall(require, 'modules.lsp.settings.' .. server)
    if (res) then
        return module
    else
        return {}
    end
end


local servers = { 'rust_analyzer', 'sumneko_lua' }
for _, server in ipairs(servers) do
    lsp[server].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = load_settings(server)
    }
end

-- enable diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        underline = false,
        signs = true,
        update_in_insert = true,
    }
)

-- status
status.register_progress()
status.config({
    current_function = false,

    indicator_errors = 'E',
    indicator_warnings = 'W',
    indicator_info = 'I',
    indicator_hint = '?',
    indicator_ok = 'Ok',
})
