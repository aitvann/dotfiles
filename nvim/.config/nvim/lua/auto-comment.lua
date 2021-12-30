local toggling = require 'toggling'

local mapx = require 'mapx'
mapx.setup { global = 'force' }

nnoremap('<leader>tc', '<cmd> lua require"toggling".toggle"auto_comment"<CR>', 'silent')
toggling.register_initial('auto_comment', false)
toggling.register_description('auto_comment', 'Auto-comment')
toggling.register_on_enable('auto_comment', function()
    vim.cmd [[set formatoptions+=cro]]
end)
toggling.register_on_disable('auto_comment', function()
    vim.cmd [[set formatoptions-=cro]]
end)
