local telescope = require("telescope.builtin")

return function(_, _, buffer)
    vim.keymap.set("n", "gs", telescope.lsp_document_symbols,
        { silent = true, buffer = buffer, desc = "Go to DOCUMENT Symbols" }
    )
end
