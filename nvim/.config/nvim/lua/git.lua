local neogit = require 'neogit'
local diffview = require 'diffview'
local gitsigns = require 'gitsigns'

local which_key = require 'which-key'
local builtin = require 'telescope.builtin'

local mapx = require 'mapx'

neogit.setup {
    disable_signs = false,
    disable_hint = true,
    disable_context_highlighting = false,
    disable_commit_confirmation = true,
    auto_refresh = true,
    disable_builtin_notifications = false,
    commit_popup = {
        kind = 'split',
    },
    -- Change the default way of opening neogit
    kind = 'tab',
    -- customize displayed signs
    signs = {
        -- { CLOSED, OPENED }
        section = { '>', 'v' },
        item = { '>', 'v' },
        hunk = { '', '' },
    },
    integrations = {
        diffview = true,
    },
    -- Setting any section to `false` will make the section not render at all
    sections = {
        untracked = {
            folded = false,
        },
        unstaged = {
            folded = false,
        },
        staged = {
            folded = false,
        },
        stashes = {
            folded = true,
        },
        unpulled = {
            folded = false,
        },
        unmerged = {
            folded = true,
        },
        recent = {
            folded = false,
        },
    },
    -- override/add mappings
    mappings = {
        -- modify status buffer mappings
        status = {
            ['<Space>'] = 'Toggle',
            ['<Esc>'] = 'Close',
            ['<Enter>'] = 'GoToFile',
        },
    },
}

local actions = require 'diffview.actions'

diffview.setup {
    diff_binaries = false, -- Show diffs for binaries
    enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
    use_icons = false, -- Requires nvim-web-devicons
    icons = { -- Only applies when use_icons is true.
        folder_closed = '',
        folder_open = '',
    },
    signs = {
        fold_closed = '',
        fold_open = '',
    },
    file_panel = {
        listing_style = 'tree', -- One of 'list' or 'tree'
        tree_options = { -- Only applies when listing_style is 'tree'
            flatten_dirs = true, -- Flatten dirs that only contain one single dir
            folder_statuses = 'only_folded', -- One of 'never', 'only_folded' or 'always'.
        },
    },
    default_args = { -- Default args prepended to the arg-list for the listed commands
        DiffviewOpen = {},
        DiffviewFileHistory = {},
    },
    hooks = {}, -- See ':h diffview-config-hooks'
    keymaps = {
        disable_defaults = true, -- Disable the default key bindings
        -- The `view` bindings are active in the diff buffers, only when the current
        -- tabpage is a Diffview.
        view = {
            ['<Tab>'] = actions.select_next_entry, -- Open the diff for the next file
            ['<S-Tab>'] = actions.select_prev_entry, -- Open the diff for the previous file
            ['<Enter>'] = actions.goto_file, -- Open the file in a new split in previous tabpage
            ['<C-w><C-f>'] = actions.goto_file_split, -- Open the file in a new split
            ['<C-w><Enter>'] = actions.goto_file_tab, -- Open the file in a new tabpage
            ['<leader>e'] = actions.focus_files, -- Bring focus to the files panel
            ['<leader>b'] = actions.toggle_files, -- Toggle the files panel.
        },
        file_panel = {
            ['j'] = actions.next_entry, -- Bring the cursor to the next file entry
            ['<down>'] = actions.next_entry,
            ['k'] = actions.prev_entry, -- Bring the cursor to the previous file entry.
            ['<up>'] = actions.prev_entry,
            ['<Space>'] = actions.select_entry, -- Open the diff for the selected entry.
            ['o'] = actions.select_entry,
            ['<2-LeftMouse>'] = actions.select_entry,
            ['-'] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
            ['S'] = actions.stage_all, -- Stage all entries.
            ['U'] = actions.unstage_all, -- Unstage all entries.
            ['X'] = actions.restore_entry, -- Restore entry to the state on the left side.
            ['R'] = actions.refresh_files, -- Update stats and entries in the file list.
            ['<Tab>'] = actions.select_next_entry,
            ['<S-Tab>'] = actions.select_prev_entry,
            ['<Enter>'] = actions.goto_file,
            ['<C-w><C-f>'] = actions.goto_file_split,
            ['<C-w><Enter>'] = actions.goto_file_tab,
            ['i'] = actions.listing_style, -- Toggle between 'list' and 'tree' views
            ['f'] = actions.toggle_flatten_dirs, -- Flatten empty subdirectories in tree listing style.
            ['<leader>e'] = actions.focus_files,
            ['<leader>b'] = actions.toggle_files,
        },
        file_history_panel = {
            ['g!'] = actions.options, -- Open the option panel
            ['<C-A-d>'] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
            ['y'] = actions.copy_hash, -- Copy the commit hash of the entry under the cursor
            ['zR'] = actions.open_all_folds,
            ['zM'] = actions.close_all_folds,
            ['j'] = actions.next_entry,
            ['<down>'] = actions.next_entry,
            ['k'] = actions.prev_entry,
            ['<up>'] = actions.prev_entry,
            ['<cr>'] = actions.select_entry,
            ['o'] = actions.select_entry,
            ['<2-LeftMouse>'] = actions.select_entry,
            ['<Tab>'] = actions.select_next_entry,
            ['<S-Tab>'] = actions.select_prev_entry,
            ['<Enter>'] = actions.goto_file,
            ['<C-w><C-f>'] = actions.goto_file_split,
            ['<C-w><Enter>'] = actions.goto_file_tab,
            ['<leader>e'] = actions.focus_files,
            ['<leader>b'] = actions.toggle_files,
        },
        option_panel = {
            ['<Space>'] = actions.select_entry,
            ['q'] = actions.close,
        },
    },
}

gitsigns.setup {
    signs = {
        add = { hl = 'GitSignsAdd', text = '▍', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change = { hl = 'GitSignsChange', text = '▍', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete = { hl = 'GitSignsDelete', text = '▸', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete = { hl = 'GitSignsDelete', text = '▾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = {
            hl = 'GitSignsChange',
            text = '▍',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn',
        },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    keymaps = {
        -- Default keymap options
        noremap = true,

        ['n ]h'] = { expr = true, '&diff ? \']c\' : \'<cmd>Gitsigns next_hunk<CR>\'' },
        ['n [h'] = { expr = true, '&diff ? \'[c\' : \'<cmd>Gitsigns prev_hunk<CR>\'' },

        ['n <leader>hs'] = '<cmd>Gitsigns stage_hunk<CR>',
        ['v <leader>hs'] = ':Gitsigns stage_hunk<CR>',
        ['n <leader>hu'] = '<cmd>Gitsigns undo_stage_hunk<CR>',
        ['n <leader>hx'] = '<cmd>Gitsigns reset_hunk<CR>',
        ['v <leader>hx'] = ':Gitsigns reset_hunk<CR>',
        ['n <leader>gX'] = '<cmd>Gitsigns reset_buffer<CR>',
        ['n <leader>hp'] = '<cmd>Gitsigns preview_hunk<CR>',
        ['n <leader>gB'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
        ['n <leader>gS'] = '<cmd>Gitsigns stage_buffer<CR>',
        ['n <leader>gU'] = '<cmd>Gitsigns reset_buffer_index<CR>',

        -- Text objects
        ['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
        ['x ih'] = ':<C-U>Gitsigns select_hunk<CR>',
    },
    watch_gitdir = {
        interval = 1000,
        follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter_opts = {
        relative_time = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
    },
    yadm = {
        enable = false,
    },
}

which_key.register({
    ['<leader>'] = {
        h = {
            name = 'Hunk',
            s = 'Stage Hunk',
            u = 'Unstage Hunk',
            x = 'Reset Hunk',
            p = 'Preview Hunk',
        },
        g = {
            name = 'Git',
            X = 'Git Reset BUFFER',
            B = 'Git show current line Blame',
            S = 'Git Stage BUFFER',
            U = 'Git reset BUFFER index',
        },
    },
}, { mode = 'n' })

which_key.register({
    ['<leader>h'] = {
        name = 'Hunk',
        s = 'Stage selected Hunks',
        x = 'RESET selected Hunks',
    },
}, { mode = 'v' })

which_key.register {
    [']h'] = 'GOTO NEXT Hunk',
    ['[h'] = 'GOTO PREVIOUS Hunk',
}

mapx.nname('<leader>g', 'Git')
-- stylua: ignore start
mapx.group('silent', function()
    nnoremap('<leader>gs', function() neogit.open() end, 'open Git Status')
    nnoremap('<leader>gm', function() builtin.git_commits() end, 'open Git coMMits')
    nnoremap('<leader>gb', function() builtin.git_branches() end, 'open Git Branches')
end)
-- stylua: ignore end
