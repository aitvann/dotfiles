require("live-rename").setup({
    hl = {
        current = "LspReferenceText",
        others = "LspReferenceText",
    },
})

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("live_rename_winfixbuf", { clear = true }),
    desc = "Lock live-rename windows to their buffers",
    pattern = "lsp:rename",
    callback = function(event)
        for winid in vim.iter(vim.fn.win_findbuf(event.buf)) do
            vim.wo[winid].winfixbuf = true
        end
    end,
})
