local telescope = require 'telescope.builtin'

return function(_)
    nnoremap('gt', function()
        telescope.lsp_type_definitions()
    end, 'silent', 'buffer')
end
