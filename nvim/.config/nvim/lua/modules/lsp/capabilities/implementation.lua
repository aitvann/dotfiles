local telescope = require 'telescope.builtin'

return function(_)
    nnoremap('gi', function()
        telescope.lsp_implementations()
    end, 'silent', 'buffer')
end
