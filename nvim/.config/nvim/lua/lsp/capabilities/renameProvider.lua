local renamer = require 'renamer'
local renamer_utils = require 'renamer.mappings.utils'
local mapx = require 'mapx'

return function(_)
    mapx.group('silent', 'buffer', function()
        nnoremap('<leader>r', function()
            renamer.rename()
        end, 'PARTIALLY Rename object under cursor')

        nnoremap('<leader>R', function()
            renamer.rename()
            renamer_utils.clear_line()
        end, 'COPLETELY Rename object under cursor')
    end)
end
