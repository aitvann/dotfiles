local telescope = require("telescope.builtin")

return function(_, _, buffer)
    vim.keymap.set("n", "gr", telescope.lsp_references, { silent = true, buffer = buffer, desc = "Go to References" })
end
