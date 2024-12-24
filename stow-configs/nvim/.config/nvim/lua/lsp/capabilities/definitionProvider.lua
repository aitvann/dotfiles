local telescope = require("telescope.builtin")

return function(_, _, client)
    vim.keymap.set("n", "gd", telescope.lsp_definitions, { silent = true, buffer = buffer, desc = "Go to Definitions" })
end
