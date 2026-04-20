local fzf_lua = require("fzf-lua")

return function(_, _, buffer)
    vim.keymap.set("n", "gd", fzf_lua.lsp_definitions, { silent = true, buffer = buffer, desc = "Go to Definitions" })
end
