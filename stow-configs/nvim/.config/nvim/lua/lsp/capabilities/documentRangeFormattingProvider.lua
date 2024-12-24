return function(_, _, buffer)
    -- stylua: ignore start
    vim.keymap.set("x", "<leader>f", function()
            -- specifying client breaks formatting
            vim.lsp.buf.format({ bufnr = buffer })
        end,
        { silent = true, buffer = buffer, desc = "Format selected range" }
    )
    -- stylua: ignore end
end
