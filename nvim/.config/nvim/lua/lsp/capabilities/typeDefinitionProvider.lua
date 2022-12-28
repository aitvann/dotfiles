local telescope = require 'telescope.builtin'

return function(_)
    nnoremap('gD', function()
        telescope.lsp_type_definitions()
    end, 'silent', 'buffer', 'Go to type Definitions')
end
