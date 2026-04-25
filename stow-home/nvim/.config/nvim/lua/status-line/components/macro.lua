-- https://github.com/nvim-lualine/lualine.nvim/issues/1355
-- https://github.com/nvim-lualine/lualine.nvim/pull/1227
return {
    'macro',
    fmt = function()
        local reg = vim.fn.reg_recording()
        if reg ~= "" then
            return "Recording @" .. reg
        end
        return nil
    end,
    color = { fg = "#ff9e64" },
    draw_empty = false,
}
