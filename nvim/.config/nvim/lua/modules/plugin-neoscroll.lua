local neoscroll = require('neoscroll') 
local config = require('neoscroll.config') 

neoscroll.setup({
    hide_cursor = false,          -- Hide cursor while scrolling
    stop_eof = false,             -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = true,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = 'quadratic',
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,              -- Function to run after the scrolling animation ends
})

local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
t['<Up>'] = {'scroll', {'-5', 'true', '50'}}
t['<Down>'] = {'scroll', { '5', 'true', '50'}}

config.set_mappings(t)
