local toggling = require("toggling")

local comment = require("Comment")

comment.setup({
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil, --
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'ъъ', -- disable
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
    },
    ---Function to call before (un)comment
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    ---Function to call after (un)comment
    post_hook = nil,
})

-- gc = Comment

vim.keymap.set("n", "<leader>tc", function()
    toggling.toggle("auto_comment")
end, { silent = true, desc = "Toggle auto-Comment" })
toggling.register({
    name = "auto_comment",
    description = "Auto-comment",
    on_enable_hook = function()
        vim.cmd([[set formatoptions+=cro]])
    end,
    on_disable_hook = function()
        vim.cmd([[set formatoptions-=cro]])
    end
})
