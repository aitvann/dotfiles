local lsp_utils = require 'modules.lsp.utils'
local toggling = require 'toggling'
local diagnostics = require 'modules.lsp.diagnostics'

local lsp = require 'lspconfig'
local cmp = require 'cmp_nvim_lsp'
local status = require 'lsp-status'
local signature = require 'lsp_signature'
local null_ls = require 'null-ls'

local servers = {
    'rust_analyzer', --rust
    'sumneko_lua', --lua
}
local options = lsp_utils.load_options(servers)

-- apply handlers
lsp_utils.apply_handlers()

-- compose `to_attach` functions
local on_attach = function(client)
    local server_options = options[client.name] or lsp_utils.load_options_for(client.name)
    server_options.on_attach(client)

    signature.on_attach(client)
    status.on_attach(client)
    diagnostics.on_attach(client)

    lsp_utils.resolve_capabilities(client.resolved_capabilities)
end

-- construct capabilities object
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp.update_capabilities(capabilities) -- update capabilities from 'cmp_nvim_lsp` plugin
capabilities = vim.tbl_extend('keep', capabilities, status.capabilities) -- update capabilities from `lsp-status` plugin

for server_name, server_options in pairs(options) do
    lsp[server_name].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = server_options.settings,
    }
end

-- null-ls
null_ls.setup {
    on_attach = on_attach,
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.write_good.with {
            filetypes = { 'markdown' },
        },
        null_ls.builtins.formatting.prettier.with {
            filetypes = { 'html', 'json', 'yaml' },
        },
    },
}

-- status
status.register_progress()

-- formatting
toggling.register_initial('fmt_on_save', true)
toggling.register_description('fmt_on_save', 'Formatting on save')
