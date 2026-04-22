return function(_, _client, buffer)
    vim.keymap.set({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action,
        { silent = true, buffer = buffer, desc = "show code Actions" }
    )
end
