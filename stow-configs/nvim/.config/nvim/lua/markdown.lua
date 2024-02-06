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

    mappings = {
        -- Toggle check-boxes.
        ["<localleader>c"] = {
            action = function()
                return require("obsidian").util.toggle_checkbox()
            end,
            opts = { buffer = true },
        },
    },

    finder_mappings = {
        -- FIXME: does not work
        -- Create a new note from your query with `:ObsidianSearch` and `:ObsidianQuickSwitch`.
        new = "<C-i>",
    },

    disable_frontmatter = true,

    ui = {
        enable = true,         -- set to false to disable all additionak syntax features
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
        vim.keymap.set("n", "<localleader>r", function()
            local newName = vim.fn.input("New note name: ")
            vim.api.nvim_cmd({ cmd = 'ObsidianRename', args = { newName } }, {})
        end, { silent = true, desc = "really RENAME current note" })
    end,
    desc = "markdown",
})
