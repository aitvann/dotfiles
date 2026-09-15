local res, live_rename = pcall(require, "live-rename")

local rename
local full_rename
if res and live_rename then
    rename = live_rename.rename
    full_rename = function()
        live_rename.rename({ text = "", insert = true })
    end
else
    rename = vim.lsp.buf.rename
    full_rename = vim.lsp.buf.rename
end

-- NOTE: could also be implemented with overriden `vim.ui.input` element, like
-- [floating-input.nvim](https://github.com/liangxianzhe/floating-input.nvim)
return function(_, _, buffer)
    vim.keymap.set("n", "<leader>r", rename,
        { silent = true, buffer = buffer, desc = "PARTIALLY Rename object under cursor" })
    vim.keymap.set("n", "<leader>R", full_rename,
        { silent = true, buffer = buffer, desc = "COPLETELY Rename object under cursor" })
end
