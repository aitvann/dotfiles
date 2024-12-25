require("obsidian").setup({
    workspaces = {
        {
            name = "personal",
            path = "~/data/knowledge-base",
        },
    },

    daily_notes = {
        folder = "daily",
        template = "default.md"
    },

    completion = {
        nvim_cmp = false,
    },

    templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
    },

    attachments = {
        img_folder = "media/images",
    },

    -- disable backlinks tips
    log_level = vim.log.levels.WARN,

    -- disable all mappings
    mappings = {},

    finder_mappings = {
        -- TODO: integrate with normal Telescope workflow
        -- Create a new note from your query with `:ObsidianSearch` and `:ObsidianQuickSwitch`.
        new = "<C-i>",
    },

    disable_frontmatter = true,

    ui = {
        -- FIXME: nice feature but require conceallevel to be <> 0 by default
        enable = false,        -- set to false to disable all additionak syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        -- Define how various check-boxes are displayed
        checkboxes = {
            -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
            [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
            ["x"] = { char = "", hl_group = "ObsidianDone" },
            [">"] = { char = "", hl_group = "ObsidianRightArrow" },
            ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        },
        -- FIXME: does not work
        -- Use bullet marks for non-checkbox lists.
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
    }
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("markdown", { clear = true }),
    pattern = "markdown",
    callback = function()
        vim.o.textwidth = 80
        vim.o.linebreak = true
        -- https://github.com/neovim/neovim/issues/14626
        -- vim.o.colorcolumn = 80
        vim.cmd [[ setlocal colorcolumn=80 ]]

        vim.cmd [[
            let b:surround_{char2nr('~')} = "~~\r~~"
            let b:surround_{char2nr('i')} = "*\r*"
            let b:surround_{char2nr('o')} = "**\r**" " bOld
            let b:surround_{char2nr('c')} = "`\r`"
            let b:surround_{char2nr('C')} = "```\r```"
            let b:surround_{char2nr('k')} = "[\r]()" " linK
            let b:surround_{char2nr('K')} = "[[|\r]\]" " linK
        ]]

        -- FIXME: does not work
        vim.keymap.set("n", "<localleader>f", "<cmd>ObsidianQuickSwitch<CR>",
            { silent = true, desc = "Go to File (Note)" })

        vim.keymap.set("n", "<localleader>d", "<cmd>ObsidianToday<CR>", { silent = true, desc = "go to toDay's note" })
        vim.keymap.set("n", "<localleader>b", "<cmd>ObsidianBacklinks<CR>",
            { silent = true, desc = "open backlinks (References) to current file" })
        vim.keymap.set("n", "<localleader>t", "<cmd>ObsidianTemplate<CR>", { silent = true, desc = "insert Template" })

        -- FIXME: does not work, event the simples `:ObsidianRename Test`
        vim.keymap.set("n", "<localleader>r", function()
            local newName = vim.fn.input("New note name: ")
            vim.api.nvim_cmd({ cmd = 'ObsidianRename', args = { newName .. '--dry-run' } }, {})
        end, { silent = true, desc = "Rename current note but just pretend" })
        vim.keymap.set("n", "<localleader>R", function()
            local newName = vim.fn.input("New note name: ")
            vim.api.nvim_cmd({ cmd = 'ObsidianRename', args = { newName } }, {})
        end, { silent = true, desc = "really RENAME current note" })

        require("autolist").setup()

        vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
        vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
        vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
        vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
        vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")

        vim.keymap.set("n", "<localleader>c", "<cmd>AutolistToggleCheckbox<cr>")
        vim.keymap.set("n", "<C-A>", "<cmd>AutolistCycleNext<cr><C-A>", { noremap = true })
        vim.keymap.set("n", "<C-X>", "<cmd>AutolistCyclePrev<cr><C-X>", { noremap = true })

        -- want dot-repeat
        -- vim.keymap.set("n", "<leader>ln", require("autolist").cycle_next_dr, { expr = true })
        -- vim.keymap.set("n", "<leader>lp", require("autolist").cycle_prev_dr, { expr = true })

        vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

        -- functions to recalculate list on edit
        vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
        vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
        vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
        vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
    end,
    desc = "markdown",
})
