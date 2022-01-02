local telescope = require 'telescope'
local actions = require 'telescope.actions'
local builtin = require 'telescope.builtin'

local mapx = require 'mapx'

telescope.setup {
    defaults = {
        prompt_prefix = ' ',
        path_display = { 'smart' },
        dynamic_preview_title = true,
        scroll_strategy = 'limit',
        selection_strategy = 'closest',
        sorting_strategy = 'ascending',

        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
        },

        file_ignore_patterns = {
            '%.git/.*',
            '%.vim/.*',
            'node_modules/.*',
            '%.idea/.*',
            '%.vscode/.*',
            '%.history/.*',
        },

        layout_config = {
            prompt_position = 'top',
        },

        mappings = {
            i = {
                ['<Down>'] = actions.move_selection_next,
                ['<Up>'] = actions.move_selection_previous,

                ['<C-n>'] = actions.cycle_history_next,
                ['<C-p>'] = actions.cycle_history_prev,

                ['<Esc>'] = actions.close,
                ['<c-d>'] = actions.delete_buffer,

                ['<CR>'] = actions.select_default,
                ['<C-x>'] = actions.select_horizontal,
                ['<C-v>'] = actions.select_vertical,
                ['<C-t>'] = actions.select_tab,

                ['<S-Up>'] = actions.preview_scrolling_up,
                ['<S-Down>'] = actions.preview_scrolling_down,

                ['<PageUp>'] = actions.results_scrolling_up,
                ['<PageDown>'] = actions.results_scrolling_down,

                ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
                ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,

                ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
                ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
                ['<C-l>'] = actions.complete_tag,
                ['<C-_>'] = actions.which_key, -- keys from pressing <C-/>
            },

            n = {
                ['<esc>'] = actions.close,
                ['<CR>'] = actions.select_default,
                ['<C-x>'] = actions.select_horizontal,
                ['<C-v>'] = actions.select_vertical,
                ['<C-t>'] = actions.select_tab,

                ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
                ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
                ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
                ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

                ['j'] = actions.move_selection_next,
                ['k'] = actions.move_selection_previous,
                ['H'] = actions.move_to_top,
                ['M'] = actions.move_to_middle,
                ['L'] = actions.move_to_bottom,

                ['<Down>'] = actions.move_selection_next,
                ['<Up>'] = actions.move_selection_previous,
                ['gg'] = actions.move_to_top,
                ['G'] = actions.move_to_bottom,

                ['<C-u>'] = actions.preview_scrolling_up,
                ['<C-d>'] = actions.preview_scrolling_down,

                ['<PageUp>'] = actions.results_scrolling_up,
                ['<PageDown>'] = actions.results_scrolling_down,

                ['?'] = actions.which_key,
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
    },
}

telescope.load_extension 'emoji'
telescope.load_extension 'fzf'

-- stylua: ignore start
mapx.group('silent', function()
    -- general
    nnoremap('gf', function() builtin.find_files { hidden = true } end)
    nnoremap('gw', function() builtin.current_buffer_fuzzy_find() end)
    nnoremap('gW', function() builtin.live_grep() end)
    nnoremap('gb', function() builtin.buffers() end)
    nnoremap('gJ', function() builtin.jumplist() end)
    inoremap('<C-j>', function() telescope.extensions.emoji.search() end)

    -- git
    nnoremap('<leader>gm', function() builtin.git_commits() end)
    nnoremap('<leader>gb', function() builtin.git_branches() end)
end)
-- stylua: ignore end
