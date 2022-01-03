local mapx = require 'mapx'

vim.cmd [[

    let g:startify_session_before_save = [ 'call CloseGit()' ]

    function! CloseGit()
        exec 'DiffviewClose'
        call luaeval('require"utils".close_buffer_by_name"NeogitStatus"')
    endfunction
]]

mapx.group('silent', function()
    noremap('<leader>sl', '<cmd>SLoad<CR>')
    noremap('<leader>ss', '<cmd>SSave<CR>')
    noremap('<leader>sd', '<cmd>SDelete<CR>')
    noremap('<leader>sc', '<cmd>SClose<CR>')
end)
