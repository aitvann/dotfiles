local telescope = require 'telescope.builtin'
local telescope_themes = require 'telescope.themes'

return function(_)
    nnoremap('<leader>a', function()
        vim.cmd 'CodeActionMenu'
    end, 'silent', 'buffer', 'show code Actions')
end
