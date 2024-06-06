require("lsp.plugin-renamer")

local lsp_utils = require("lsp.utils")
local toggling = require("toggling")
local diagnostics = require("lsp.diagnostics")

local lsp = require("lspconfig")
local cmp = require("cmp_nvim_lsp")
local status = require("lsp-status")
local signature = require("lsp_signature")
local inlay_hints = require("lsp-inlayhints")

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
    server_options.on_attach(client)

    signature.on_attach({
        hint_enable = false,
    })
    status.on_attach(client)
    diagnostics.on_attach(client)
    inlay_hints.on_attach(client, buffer)

    lsp_utils.resolve_capabilities(client.server_capabilities)
end

-- construct capabilities object
local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    cmp.default_capabilities(), -- update capabilities from 'cmp_nvim_lsp` plugin
    status.capabilities         -- update capabilities from `lsp-status` plugin
)

for server_name, server_options in pairs(options) do
    lsp[server_name].setup({
        init_options = server_options.init_options,
        cmd = server_options.cmd,
        on_attach = on_attach,
        capabilities = capabilities,
        settings = server_options.settings,
        filetypes = server_options.filetypes,
    })
end

-- inlay_hints
inlay_hints.setup({
    eol = {
        type = {
            format = function(hints)
                return string.format("%s", hints)
            end,
        },
    },
})

-- status
status.register_progress()

-- formatting
toggling.register({
    name = "fmt_on_save",
    initial = true,
    description = "Formatting on save",
})
