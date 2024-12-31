require("lsp.plugin-renamer")

local lsp_utils = require("lsp.utils")
local toggling = require("toggling")
local diagnostics = require("lsp.diagnostics")

local lsp = require("lspconfig")
local cmp = require("cmp_nvim_lsp")
local status = require("lsp-status")
local signature = require("lsp_signature")

local servers = {
    "rust_analyzer", -- rust
    "solc",          -- solidity
    "lua_ls",        -- lua
    "nil_ls",        -- nix
    "marksman",      -- markdown
    "clojure_lsp",   -- clojure
    "taplo",         -- toml
    "efm"
}
local options = lsp_utils.load_options(servers)

-- apply handlers
lsp_utils.apply_handlers()

-- compose `to_attach` functions
local on_attach = function(client, buffer)
    local server_options = options[client.name] or lsp_utils.load_options_for(client.name)
    server_options.on_attach(client, buffer)

    signature.on_attach({
        hint_enable = false,
    }, buffer)
    status.on_attach(client)
    diagnostics.on_attach(client, buffer)

    lsp_utils.resolve_capabilities(client, buffer)
end

-- construct capabilities object
local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    cmp.default_capabilities(), -- update capabilities from 'cmp_nvim_lsp` plugin
    status.capabilities         -- update capabilities from `lsp-status` plugin
)

-- ignore the error
for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end

for server_name, server_options in pairs(options) do
    lsp[server_name].setup({
        init_options = server_options.init_options,
        cmd = server_options.cmd,
        -- deprecated: LspAttach autocommand is used
        -- on_attach = on_attach,
        capabilities = capabilities,
        settings = server_options.settings,
        filetypes = server_options.filetypes,
    })
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buffer = args.buf
        on_attach(client, buffer)
    end,
})

-- status
status.register_progress()

-- formatting
toggling.register({
    name = "fmt_on_save",
    initial = true,
    description = "Formatting on save",
})

toggling.register({
    name = "inlay_hints",
    initial = false,
    description = "Display inlay hints",
})
