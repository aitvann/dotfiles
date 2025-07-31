local telescope = require("telescope.builtin")

return function(_, _, buffer)
    vim.keymap.set("n", "gS", telescope.lsp_workspace_symbols,
        { silent = true, buffer = buffer, desc = "Go to WORKSPACE Symbols" }
    )
end
