require("nnn").setup({
    picker = {
        cmd = "tmux new-session nnn -Pv",
        session = "local",
        style = { border = "rounded" },
    },
})

vim.keymap.set("n", "<leader>e", function()
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath ~= "" and vim.fn.filereadable(filepath) == 1 then
        vim.api.nvim_cmd({ cmd = 'NnnPicker', args = { filepath } }, {})
    else
        vim.api.nvim_cmd({ cmd = 'NnnPicker' }, {})
    end
end, { silent = true, desc = "open Git coMMits" })
