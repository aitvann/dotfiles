require("autolist").setup()

vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")

vim.keymap.set("n", "<C-S-A>", "<cmd>AutolistToggleCheckbox<cr>")
vim.keymap.set("n", "<C-A>", "<cmd>AutolistCycleNext<cr><C-A>", { noremap = true })
vim.keymap.set("n", "<C-X>", "<cmd>AutolistCyclePrev<cr><C-X>", { noremap = true })

-- want dot-repeat
-- vim.keymap.set("n", "<leader>ln", require("autolist").cycle_next_dr, { expr = true })
-- vim.keymap.set("n", "<leader>lp", require("autolist").cycle_prev_dr, { expr = true })

vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

-- functions to recalculate list on edit
vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
