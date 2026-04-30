require("live-rename").setup({
    hl = {
        current = "LspReferenceText",
        others = "LspReferenceText",
    },
})

local print_msg = function()
    print('A keymap that would usually swap buffer in the current window was pressed. The action was prevented')
end

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("rename_buf_solid", { clear = true }),
    desc = "Delete mappings that swap buffers",
    pattern = "lsp:rename",
    callback = function(event)
        local opts = { buf = event.buf }

        -- just `vim.keymap.del` does not work for <C-i> and <C-o> for some reason
        vim.keymap.set("n", "<Tab>", print_msg, opts);
        vim.keymap.set("n", "<S-Tab>", print_msg, opts);
        vim.keymap.set("n", "<C-i>", print_msg, opts);
        vim.keymap.set("n", "<C-o>", print_msg, opts);
    end,
})
