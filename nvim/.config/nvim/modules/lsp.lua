local config = require'lspconfig'
local completion = require'completion'
local status = require'lsp-status'
local fzf = require'fzf_lsp'

status.register_progress()

-- function to attach completion when setting up lsp
local on_attach = function(client)
    completion.on_attach(client)
    status.on_attach(client)
end

-- Enable rust_analyzer
config.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = status.capabilities
})

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

