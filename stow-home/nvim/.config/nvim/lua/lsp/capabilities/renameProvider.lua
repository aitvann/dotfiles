return function(_, _, buffer)
    vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename(nil, { bufnr = buffer }) end,
        { silent = true, buffer = buffer, desc = "PARTIALLY Rename object under cursor" })
    -- vim.keymap.set("n", "<leader>R", function()
    --     renamer.rename({ empty = true })
    -- end, { silent = true, buffer = buffer, desc = "COPLETELY Rename object under cursor" })
end
