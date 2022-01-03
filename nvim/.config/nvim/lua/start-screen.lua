local mapx = require 'mapx'

vim.cmd [[
    let g:startify_session_dir = $HOME . '/.config/nvim/sessions'
    let g:startify_change_to_vcs_root = 1
    let g:startify_custom_indices = ['a', 'd', 'f', 'l', 'w', 'r', 'u', 'o', 'x', 'c', 'm', 'n', 'z', 'y', 'p']
    let g:startify_lists = [
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ ]
    let g:startify_custom_header = [
        \ '⠀⠀⠀⠀⢶⣶⣶⣶⣶⡄⠀⢲⣶⣶⣶⣶⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
        \ '⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣄⠀⠻⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
        \ '⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣧⡀⠙⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
        \ '⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣷⣄⠈⢿⣿⣿⣿⣷⣄⠀⢤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡄⠀⠀⠀⣤⣤⠀⠀⠀⢠⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⢠⣤⠀⠀⠀⠀',
        \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣆⠀⠻⣿⣿⣿⣿⣆⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⣿⣿⠀⠀⠀⢸⣿⡇⠀⣀⣤⣤⣀⡀⢀⣀⣤⣄⡀⠀⣿⡇⠀⢀⣀⠀⢀⣠⣤⣀⠀⢸⣿⢸⣿⠀⠀⠀⠀',
        \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢙⣿⣿⣿⣿⡧⠀⢘⣿⣿⣿⣿⣧⡀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⣿⣿⠶⠶⠶⢾⣿⡇⠚⠋⠁⣈⣿⣷⣿⣯⣀⡉⠛⠃⣿⣇⣴⡟⠁⣴⣿⣉⣉⣹⣷⢸⣿⢸⣿⠀⠀⠀⠀',
        \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⡟⠀⣠⣿⣿⣿⣿⣿⣿⣿⣄⠈⢻⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⣿⣿⠀⠀⠀⢸⣿⡇⣾⡟⠋⠉⣿⣿⣈⡉⠙⠻⣿⡆⣿⡟⠹⣿⡄⣿⣏⠉⠉⢉⣉⢹⣿⢸⣿⠀⠀⠀⠀',
        \ '⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⠋⠀⣴⣿⣿⣿⣿⠿⣿⣿⣿⣿⣆⠀⠹⠿⠿⠿⠿⠿⠇⠀⠀⠀⠿⠿⠀⠀⠀⠸⠿⠇⠻⠷⠶⠞⠿⠿⠙⠷⠶⠶⠟⠃⠿⠇⠀⠘⠿⠮⠻⠷⠶⠿⠋⠸⠿⠸⠿⠀⠀⠀⠀',
        \ '⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⡿⠃⢀⣾⣿⣿⣿⡿⠃⠀⠘⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
        \ '⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⠟⠁⣰⣿⣿⣿⣿⡟⠁⠀⠀⠀⠈⢻⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
        \ '⠀⠀⠀⠀⠼⠿⠿⠿⠿⠋⠀⠼⠿⠿⠿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠻⠿⠿⠿⠿⠧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
        \]
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
