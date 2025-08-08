require("lsp.plugin-renamer")

local lsp_utils = require("lsp.utils")
local toggling = require("toggling")
local diagnostics = require("lsp.diagnostics")

local lsp = require("lspconfig")
local blink = require("blink.cmp")
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
    diagnostics.on_attach(client, buffer)

    lsp_utils.resolve_capabilities(client, buffer)
end

-- construct capabilities object
local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities() -- update capabilities from 'cmp_nvim_lsp` plugin
)

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
