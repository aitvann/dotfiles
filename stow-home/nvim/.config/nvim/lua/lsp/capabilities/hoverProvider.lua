return function(_, _, buffer)
    local opts = {
        border = "rounded"
    }

    vim.keymap.set("n", "<leader>i", function() vim.lsp.buf.hover(opts) end,
        { silent = true, buffer = buffer, desc = "Inspect node under cursor" }
    )
end
