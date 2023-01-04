local telescope = require("telescope.builtin")
local telescope_themes = require("telescope.themes")

return function(_)
	vim.keymap.set("n", "<leader>a", function()
		vim.cmd("CodeActionMenu")
	end, { silent = true, buffer = true, desc = "show code Actions" })
end
