local fzf_lua = require("fzf-lua")

return function(_, _, buffer)
    vim.keymap.set("n", "gr", fzf_lua.lsp_references, { silent = true, buffer = buffer, desc = "Go to References" })
end
