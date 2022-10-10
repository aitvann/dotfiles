local telescope = require 'telescope.builtin'

return function(_)
    nnoremap('gr', function()
        telescope.lsp_references()
    end, 'silent', 'buffer', 'Go to References')
end
