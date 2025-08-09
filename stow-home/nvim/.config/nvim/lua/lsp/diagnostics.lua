-- diagnostics does not depend on any capability

local telescope = require("telescope.builtin")
local next_integrations = require("nvim-next.integrations")

local M = {}

M.on_attach = function(_client, buffer)
    local nndiag = next_integrations.diagnostic()

    -- mappings
    -- stylua: ignore start
    vim.keymap.set("n", '<leader>M', telescope.diagnostics,
        { silent = true, desc = 'show PROJECT diagnostics (Messages)', buffer = buffer })
    vim.keymap.set("n", '<leader>m', vim.diagnostic.open_float,
        { silent = true, desc = 'show CURRENT LINE diagnostics (Messages)', buffer = buffer })
    vim.keymap.set("n", '[d', nndiag.goto_prev(), { silent = true, desc = 'GOTO PREVIOUS diagnostics', buffer = buffer })
    vim.keymap.set("n", ']d', nndiag.goto_next(), { silent = true, desc = 'GOTO NEXT diagnostics', buffer = buffer })
    -- stylua: ignore end
end

return M
