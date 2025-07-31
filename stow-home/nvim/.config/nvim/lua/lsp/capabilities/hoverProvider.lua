return function(_, _, buffer)
    vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover,
        { silent = true, buffer = buffer, desc = "Inspect node under cursor" }
    )
end
