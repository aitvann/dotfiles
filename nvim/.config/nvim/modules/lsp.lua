local lsp = require'lspconfig'
local cmp = require'cmp_nvim_lsp'
local status = require'lsp-status'
local fzf = require'fzf_lsp'

status.register_progress()

-- compose `to_attach` functions from all pluggins
local on_attach = function(client)
    status.on_attach(client)
end

-- construct capabilities object
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp.update_capabilities(capabilities) -- update capabilities from 'cmp_nvim_lsp` plugin
capabilities = vim.tbl_extend('keep', capabilities, status.capabilities) -- update capabilities from `lsp-status` plugin

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
        signs = false,
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

