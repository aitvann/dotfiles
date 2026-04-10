local lsp_utils = require("lsp.utils")
local toggling = require("toggling")
local diagnostics = require("lsp.diagnostics")

local blink = require("blink.cmp")

vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("lsp_enable", { clear = true }),
    desc = "Make sure Direnv environment is loaded before enabling LSP (fixes rust-analyzer)",
    pattern = "DirenvLoaded",
    callback = function()
        vim.lsp.enable {
            "rust_analyzer", -- rust
            "solc",          -- solidity
            "lua_ls",        -- lua
            "nixd",          -- nix
            "marksman",      -- markdown
            "clojure_lsp",   -- clojure
            "taplo",         -- toml
            "efm"
        }
    end,
})

-- construct capabilities object
local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities() -- update capabilities from 'cmp_nvim_lsp` plugin
)

vim.lsp.config('*', { capabilities = capabilities })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
    desc = "LspAttach callback",
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buffer = args.buf

        -- compose `to_attach` functions
        diagnostics.on_attach(client, buffer)

        lsp_utils.resolve_capabilities(client, buffer)
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = false,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = "WarningMsg",
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticHint",
        },
    }
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
