local telescope = require("telescope.builtin")

return function(_, _, buffer)
    vim.keymap.set("n", "gi", telescope.lsp_implementations,
        { silent = true, buffer = buffer, desc = "Go to Implementations" }
    )
end
