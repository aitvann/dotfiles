return function(_, _, _)
    vim.cmd([[
        highlight! link LspInlayHint Comment
    ]])
end
