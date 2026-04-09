-- diagnostics does not depend on any capability

local telescope = require("telescope.builtin")
local repeat_move = require("repeatable_move")

local M = {}

M.on_attach = function(_client, buffer)
    vim.keymap.set("n", '<leader>M', telescope.diagnostics,
        { silent = true, desc = 'show PROJECT diagnostics (Messages)', buffer = buffer })
    vim.keymap.set("n", '<leader>m', vim.diagnostic.open_float,
        { silent = true, desc = 'show CURRENT LINE diagnostics (Messages)', buffer = buffer })

    local jump_next = function() vim.diagnostic.jump({ count = 1 }) end
    local jump_prev = function() vim.diagnostic.jump({ count = -1 }) end
    jump_next, jump_prev = repeat_move.make_repeatable_move_pair(jump_next, jump_prev)

    vim.keymap.set({ "n", "x", "o" }, "]d", jump_next,
        { silent = true, desc = "GOTO PREVIOUS diagnostics", buffer = buffer })
    vim.keymap.set({ "n", "x", "o" }, "[d", jump_prev,
        { silent = true, desc = "GOTO NEXT diagnostics", buffer = buffer })
end

return M
