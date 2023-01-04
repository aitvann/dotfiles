local telescope = require("telescope.builtin")

return function(_)
	vim.keymap.set("n", "gd", telescope.lsp_definitions, { silent = true, buffer = true, desc = "Go to Definitions" })
end
