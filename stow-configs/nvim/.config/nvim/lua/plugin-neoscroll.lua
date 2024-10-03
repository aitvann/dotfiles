local neoscroll = require 'neoscroll'

neoscroll.setup {
    hide_cursor = false,         -- Hide cursor while scrolling
    stop_eof = false,            -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = true,    -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = 'quadratic',
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,             -- Function to run after the scrolling animation ends
}

local modes = { 'n', 'v', 'x' }
vim.keymap.set(modes, '<Up>', function() neoscroll.scroll(-5, { move_cursor = true, duration = 50 }) end,
    { desc = 'scroll DOWN' })
vim.keymap.set(modes, '<Down>', function() neoscroll.scroll(5, { move_cursor = true, duration = 50 }) end,
    { desc = 'scroll UP' })
