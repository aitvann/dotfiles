local telescope = require 'telescope.builtin'

return function(_)
    nnoremap('gd', function()
        telescope.lsp_definitions()
    end, 'silent', 'buffer', 'Go to Definitions')
end
