require("nnn").setup({
    picker = {
        cmd = "tmux new-session nnn -Pv",
        session = "local",
        style = { border = "rounded" },
    },
})

vim.keymap.set("n", "<leader>e", function()
    vim.api.nvim_cmd({ cmd = 'NnnPicker', args = { vim.api.nvim_buf_get_name(0) } }, {})
end, { silent = true, desc = "open Git coMMits" })
