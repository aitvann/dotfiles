local lsp_utils = require("lsp.utils")
local toggling = require("toggling")
local diagnostics = require("lsp.diagnostics")

local conform = require("conform")
local blink = require("blink.cmp")

vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("lsp_enable", { clear = true }),
    desc = "Make sure Direnv environment is loaded before enabling LSP (fixes rust-analyzer)",
    pattern = "DirenvLoaded",
    callback = function()
        vim.lsp.enable {
            "vimdoc_ls",     -- vimdoc
            "rust_analyzer", -- rust
            "solc",          -- solidity
            "lua_ls",        -- lua
            "nixd",          -- nix
            "marksman",      -- markdown
            "clojure_lsp",   -- clojure
            "tombi",         -- toml
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

lsp_utils.apply_handlers()

conform.setup({
    format_after_save = function(_)
        if toggling.is_enabled("fmt_on_save") then
            return { lsp_format = "prefer" }
        end
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
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
            [vim.diagnostic.severity.HINT] = "DiagnosticHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
        },
    }
})

-- Clear default LPS keymap as they conflict with Go to Reference (`gr`)
vim.keymap.del({ "n", "x" }, "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grt")
vim.keymap.del("n", "grx")

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
