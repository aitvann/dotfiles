vim.cmd [[
    let g:startify_session_dir = $HOME . '/.config/nvim/sessions'
    let g:startify_change_to_vcs_root = 1
    let g:startify_session_persistence = 1
    let g:startify_custom_indices = ['a', 'd', 'f', 'l', 'w', 'r', 'u', 'o', 'x', 'c', 'm', 'n', 'z', 'y', 'p']
    let g:startify_lists = [
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ ]
    let g:startify_custom_header = [
        \ '         ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖          ',
        \ '          ▜███▙       ▜███▙  ▟███▛         ',
        \ '           ▜███▙       ▜███▙▟███▛          ',
        \ '            ▜███▙       ▜██████▛           ',
        \ '     ▟█████████████████▙ ▜████▛     ▟▙     ',
        \ '    ▟███████████████████▙ ▜███▙    ▟██▙    ',
        \ '           ▄▄▄▄▖           ▜███▙  ▟███▛    ',
        \ '          ▟███▛             ▜██▛ ▟███▛     ',
        \ '         ▟███▛               ▜▛ ▟███▛      ',
        \ '▟███████████▛                  ▟██████████▙',
        \ '▜██████████▛                  ▟███████████▛',
        \ '      ▟███▛ ▟▙               ▟███▛         ',
        \ '     ▟███▛ ▟██▙             ▟███▛          ',
        \ '    ▟███▛  ▜███▙           ▝▀▀▀▀           ',
        \ '    ▜██▛    ▜███▙ ▜██████████████████▛     ',
        \ '     ▜▛     ▟████▙ ▜████████████████▛      ',
        \ '           ▟██████▙       ▜███▙            ',
        \ '          ▟███▛▜███▙       ▜███▙           ',
        \ '         ▟███▛  ▜███▙       ▜███▙          ',
        \ '         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘          ',
        \]
]]
