-- diagnostics does not depend on any capability

local telescope = require("telescope.builtin")

local M = {}

M.on_attach = function(_)
    -- mappings
    -- stylua: ignore start
    vim.keymap.set("n", '<leader>M', telescope.diagnostics,
        { silent = true, desc = 'show PROJECT diagnostics (Messages)' })
    vim.keymap.set("n", '<leader>m', vim.diagnostic.open_float,
        { silent = true, desc = 'show CURRENT LINE diagnostics (Messages)' })
    vim.keymap.set("n", '[d', vim.diagnostic.goto_prev, { silent = true, desc = 'GOTO NEXT diagnostics' })
    vim.keymap.set("n", ']d', vim.diagnostic.goto_next, { silent = true, desc = 'GOTO PREVIOUS diagnostics' })
	-- stylua: ignore end

	-- diagnostics in line number
	vim.cmd([[
        sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticError
        sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticWarn
        sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticInfo
        sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticHint
    ]])
end

return M
