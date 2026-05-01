local quicker = require("quicker")
local repeat_move = require("repeatable_move")

quicker.setup({
    keys = {
        {
            ">",
            function()
                quicker.expand({ before = 2, after = 2, add_to_existing = true })
            end,
            desc = "Expand quickfix context",
        },
        {
            "<",
            quicker.collapse,
            desc = "Collapse quickfix context",
        },
    },
    highlight = {
        -- Load the referenced buffers to apply more accurate highlights (may be slow)
        load_buffers = true,
    }
})

-- Repeating quickfix list jump
local qf_next = function()
    local ok, _ = pcall(vim.cmd, "cnext" .. vim.v.count1)
    if not ok then
        print("No more items in quickfix list")
    end
end

local qf_prev = function()
    local ok, _ = pcall(vim.cmd, "cprev" .. vim.v.count1)
    if not ok then
        print("No more items in quickfix list")
    end
end

qf_next, qf_prev = repeat_move.make_repeatable_move_pair(qf_next, qf_prev)
vim.keymap.set({ "n", "x", "o" }, "]<space>", qf_next, { silent = true, desc = "GOTO NEXT quickfix item" })
vim.keymap.set({ "n", "x", "o" }, "[<space>", qf_prev, { silent = true, desc = "GOTO PREVIOUS quickfix item" })
