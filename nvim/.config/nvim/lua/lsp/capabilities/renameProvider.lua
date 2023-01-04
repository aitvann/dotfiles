local renamer = require("renamer")
local renamer_utils = require("renamer.mappings.utils")

return function(_)
    -- stylua: ignore start
    vim.keymap.set("n", "<leader>r", renamer.rename, { silent = true, desc = "PARTIALLY Rename object under cursor" })
    vim.keymap.set("n", "<leader>R", function()
        renamer.rename()
        renamer_utils.clear_line()
    end, { desc = "COPLETELY Rename object under cursor" })
	-- stylua: ignore end
end
