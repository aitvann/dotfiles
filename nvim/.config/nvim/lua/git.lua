local neogit = require 'neogit'
local diffview = require 'diffview'
local gitsigns = require 'gitsigns'
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
            folded = true,
        },
        unstaged = {
            folded = true,
        },
        staged = {
            folded = true,
        },
        stashes = {
            folded = true,
        },
        unpulled = {
            folded = true,
        },
        unmerged = {
            folded = true,
        },
        recent = {
            folded = true,
        },
    },
    -- override/add mappings
    mappings = {
        -- modify status buffer mappings
        status = {
            ['<Space>'] = 'Toggle',
        },
    },
}

local cb = require('diffview.config').diffview_callback

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
        position = 'left', -- One of 'left', 'right', 'top', 'bottom'
        width = 35, -- Only applies when position is 'left' or 'right'
        height = 10, -- Only applies when position is 'top' or 'bottom'
        listing_style = 'tree', -- One of 'list' or 'tree'
        tree_options = { -- Only applies when listing_style is 'tree'
            flatten_dirs = true, -- Flatten dirs that only contain one single dir
            folder_statuses = 'only_folded', -- One of 'never', 'only_folded' or 'always'.
        },
    },
    file_history_panel = {
        position = 'bottom',
        width = 35,
        height = 16,
        log_options = {
            max_count = 256, -- Limit the number of commits
            follow = false, -- Follow renames (only for single file)
            all = false, -- Include all refs under 'refs/' including HEAD
            merges = false, -- List only merge commits
            no_merges = false, -- List no merge commits
            reverse = false, -- List commits in reverse order
        },
    },
    default_args = { -- Default args prepended to the arg-list for the listed commands
        DiffviewOpen = {},
        DiffviewFileHistory = {},
    },
    hooks = {}, -- See ':h diffview-config-hooks'
    key_bindings = {
        disable_defaults = false, -- Disable the default key bindings
        -- The `view` bindings are active in the diff buffers, only when the current
        -- tabpage is a Diffview.
        view = {
            ['<tab>'] = cb 'select_next_entry', -- Open the diff for the next file
            ['<s-tab>'] = cb 'select_prev_entry', -- Open the diff for the previous file
            ['gf'] = cb 'goto_file', -- Open the file in a new split in previous tabpage
            ['<C-w><C-f>'] = cb 'goto_file_split', -- Open the file in a new split
            ['<C-w>gf'] = cb 'goto_file_tab', -- Open the file in a new tabpage
            ['<leader>e'] = cb 'focus_files', -- Bring focus to the files panel
            ['<leader>b'] = cb 'toggle_files', -- Toggle the files panel.
        },
        file_panel = {
            ['j'] = cb 'next_entry', -- Bring the cursor to the next file entry
            ['<down>'] = cb 'next_entry',
            ['k'] = cb 'prev_entry', -- Bring the cursor to the previous file entry.
            ['<up>'] = cb 'prev_entry',
            ['<Space>'] = cb 'select_entry', -- Open the diff for the selected entry.
            ['o'] = cb 'select_entry',
            ['<2-LeftMouse>'] = cb 'select_entry',
            ['-'] = cb 'toggle_stage_entry', -- Stage / unstage the selected entry.
            ['S'] = cb 'stage_all', -- Stage all entries.
            ['U'] = cb 'unstage_all', -- Unstage all entries.
            ['X'] = cb 'restore_entry', -- Restore entry to the state on the left side.
            ['R'] = cb 'refresh_files', -- Update stats and entries in the file list.
            ['<tab>'] = cb 'select_next_entry',
            ['<s-tab>'] = cb 'select_prev_entry',
            ['gf'] = cb 'goto_file',
            ['<C-w><C-f>'] = cb 'goto_file_split',
            ['<C-w>gf'] = cb 'goto_file_tab',
            ['i'] = cb 'listing_style', -- Toggle between 'list' and 'tree' views
            ['f'] = cb 'toggle_flatten_dirs', -- Flatten empty subdirectories in tree listing style.
            ['<leader>e'] = cb 'focus_files',
            ['<leader>b'] = cb 'toggle_files',
        },
        file_history_panel = {
            ['g!'] = cb 'options', -- Open the option panel
            ['<C-A-d>'] = cb 'open_in_diffview', -- Open the entry under the cursor in a diffview
            ['y'] = cb 'copy_hash', -- Copy the commit hash of the entry under the cursor
            ['zR'] = cb 'open_all_folds',
            ['zM'] = cb 'close_all_folds',
            ['j'] = cb 'next_entry',
            ['<down>'] = cb 'next_entry',
            ['k'] = cb 'prev_entry',
            ['<up>'] = cb 'prev_entry',
            ['<cr>'] = cb 'select_entry',
            ['o'] = cb 'select_entry',
            ['<2-LeftMouse>'] = cb 'select_entry',
            ['<tab>'] = cb 'select_next_entry',
            ['<s-tab>'] = cb 'select_prev_entry',
            ['gf'] = cb 'goto_file',
            ['<C-w><C-f>'] = cb 'goto_file_split',
            ['<C-w>gf'] = cb 'goto_file_tab',
            ['<leader>e'] = cb 'focus_files',
            ['<leader>b'] = cb 'toggle_files',
        },
        option_panel = {
            ['<Space>'] = cb 'select',
            ['q'] = cb 'close',
        },
    },
}

gitsigns.setup {
    signs = {
        add = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
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
        ['n <leader>hr'] = '<cmd>Gitsigns reset_hunk<CR>',
        ['v <leader>hr'] = ':Gitsigns reset_hunk<CR>',
        ['n <leader>gR'] = '<cmd>Gitsigns reset_buffer<CR>',
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

nnoremap('<leader>gs', function()
    neogit.open()
end, 'silent')
