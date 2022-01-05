local telescope = require 'telescope.builtin'
local telescope_themes = require 'telescope.themes'

return function(_)
    nnoremap('<leader>a', function()
        local theme = telescope_themes.get_cursor()
        telescope.lsp_code_actions(theme)
    end, 'silent', 'buffer', 'show code Actions')
end
