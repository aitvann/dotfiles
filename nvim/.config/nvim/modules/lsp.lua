local lsp = require'lspconfig'
local cmp = require'cmp_nvim_lsp'
local status = require'lsp-status'
local fzf = require'fzf_lsp'
local mapx = require'mapx'
mapx.setup{ global = true }

status.register_progress()

-- compose `to_attach` functions from all pluggins
local on_attach = function(client)
    status.on_attach(client)

    -- mappings
    nnoremap("gr",          "lua vim.lsp.buf.references()", "silent")
    nnoremap("gd",          "lua vim.lsp.buf.definition()", "silent")
    nnoremap("gD",          "lua vim.lsp.buf.declaration()", "silent")
    nnoremap("gi",          "lua vim.lsp.buf.implementation()", "silent")
    nnoremap("gs",          "lua vim.lsp.buf.document_symbol()", "silent")
    nnoremap("gS",          "lua vim.lsp.buf.workspace_symbol()", "silent")
    nnoremap("<leader>a",   "lua vim.lsp.buf.code_action()", "silent")
    nnoremap("<leader>M",   "lua vim.lsp.diagnostic.show_line_diagnostics()", "silent")
    nnoremap("<leader>m",   "lua vim.lsp.diagnostic.show_line_diagnostics()", "silent")
    nnoremap("<leader>i",   "lua vim.lsp.buf.hover()", "silent")
    nnoremap("<leader>r",   "lua vim.lsp.buf.rename()", "silent")

    -- hover highlighting
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
                augroup lsp_document_highlight
                    autocmd! * <buffer>
                    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
            ]],
            false
        )
    end

    -- inline type hints
    vim.api.nvim_exec(
        [[
             augroup inline_type_hints
                 autocmd!
                 autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
                 \ lua require'lsp_extensions'.inlay_hints{ prefix = 'ᐅ ', highlight = "Comment", enabled = {"ChainingHint"} }
             augroup END
        ]],
        false
    )

    vim.cmd [[
      highlight DiagnosticLineNrError guibg=#51202A guifg=#FF0000 gui=bold
      highlight DiagnosticLineNrWarn guibg=#51412A guifg=#FFA500 gui=bold
      highlight DiagnosticLineNrInfo guibg=#1E535D guifg=#00FFFF gui=bold
      highlight DiagnosticLineNrHint guibg=#1E205D guifg=#0000FF gui=bold

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

local settings = function(path) 
    local status, module = pcall(require, path)
    if(status) then
        return module
    else
        return {}
    end
end

local servers = { "rust_analyzer" }
for _, server in ipairs(servers) do
    lsp[server].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        underline = false,
        signs = true,
        update_in_insert = true,
    }
)

status.config({
    current_function = false,

    indicator_errors = 'E',
    indicator_warnings = 'W',
    indicator_info = 'I',
    indicator_hint = '?',
    indicator_ok = 'Ok',
})

fzf.setup()

