local telescope = require("telescope.builtin")

return function(_, _, buffer)
    vim.keymap.set("n", "gD", telescope.lsp_type_definitions,
        { silent = true, buffer = buffer, desc = "Go to type Definitions" }
    )
end
