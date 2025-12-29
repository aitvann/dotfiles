require("obsidian").setup({
    workspaces = {
        {
            name = "personal",
            path = "~/data/knowledge-base",
        },
    },

    -- disable backlinks tips
    log_level = vim.log.levels.WARN,

    daily_notes = {
        folder = "daily",
        template = "default.md",
    },

    -- disable, LSP is used instead
    completion = {
        nvim_cmp = false,
        blink = false,
    },

    -- disable whatever that is
    frontmatter = {
        enabled = false
    },

    templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
    },

    picker = {
        name = "telescope.nvim",
        note_mappings = {
            new = "<C-x>",
            -- use completion instead
            insert_link = nil,
        },
        tag_mappings = {
            new = "<C-x>",
            -- use completion instead
            insert_tag = nil,
        },
    },

    note_path_func = function(spec)
        local path = spec.dir / spec.title
        return path:with_suffix(".md")
    end,

    legacy_commands = false,

    formatter = {
        disable = true
    },

    -- FIXME: nice feature but require conceallevel to be <> 0 by default
    ui = {
        enable = false,
    },

    attachments = {
        img_folder = "media/images",
    },

})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("markdown", { clear = true }),
    pattern = "markdown",
    callback = function(args)
        local buffer = args.buf
        -- 98 because this is how mush fits on half of my screen
        vim.o.textwidth = 98
        vim.o.linebreak = true
        vim.o.colorcolumn = "98"

        vim.cmd [[
            let b:surround_{char2nr('~')} = "~~\r~~"
            let b:surround_{char2nr('i')} = "*\r*"
            let b:surround_{char2nr('o')} = "**\r**" " bOld
            let b:surround_{char2nr('c')} = "`\r`"
            let b:surround_{char2nr('C')} = "```\r```"
            let b:surround_{char2nr('k')} = "[\r]()" " linK
            let b:surround_{char2nr('K')} = "[[|\r]\]" " linK
        ]]

        vim.keymap.set("n", "<localleader>d", "<cmd>Obsidian today<CR>",
            { silent = true, desc = "go to toDay's note", buffer = buffer })
        vim.keymap.set("n", "<localleader>b", "<cmd>Obsidian backlinks<CR>",
            { silent = true, desc = "open backlinks (References) to current file", buffer = buffer })
        vim.keymap.set("n", "<localleader>t", "<cmd>Obsidian template<CR>",
            { silent = true, desc = "insert Template", buffer = buffer })
        vim.keymap.set("n", "<localleader>r", "<cmd>Obsidian rename<CR>",
            { silent = true, desc = "Rename current note", buffer = buffer })
        --
        -- remap LSP keybinding
        vim.keymap.set("n", "gf", "<cmd>Obsidian quick_switch<CR>",
            { silent = true, desc = "Go to File (Note)", buffer = buffer })

        local autolist = require("autolist")
        autolist.setup({
            enabled = true,
            colon = {
                indent = true,
                indent_raw = false,
                preferred = "-",
            }
        })

        vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>", { silent = true, buffer = buffer })
        vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>", { silent = true, buffer = buffer })
        vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>", { silent = true, buffer = buffer })
        vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>", { silent = true, buffer = buffer })
        vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>", { silent = true, buffer = buffer })

        vim.keymap.set("n", "<localleader>c", "<cmd>AutolistToggleCheckbox<cr>", { silent = true, buffer = buffer })
        vim.keymap.set("n", ">b", autolist.cycle_next_dr, { expr = true, noremap = true, silent = true, buffer = buffer })
        vim.keymap.set("n", "<b", autolist.cycle_prev_dr, { expr = true, noremap = true, silent = true, buffer = buffer })

        vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>", { silent = true, buffer = buffer })

        -- functions to recalculate list on edit
        vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>", { silent = true, buffer = buffer })
        vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>", { silent = true, buffer = buffer })
        vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>", { silent = true, buffer = buffer })
        vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>", { silent = true, buffer = buffer })
    end,
    desc = "markdown",
})
