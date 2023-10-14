local telescope = require("telescope.builtin")

return function(_)
	vim.keymap.set("n", "gr", telescope.lsp_references, { silent = true, buffer = true, desc = "Go to References" })
end
