local toggling = require("toggling")

local comment = require("Comment")
local utils = require("Comment.utils")
local context = require("ts_context_commentstring.utils")
local context_internal = require("ts_context_commentstring.internal")

comment.setup({
	---Add a space b/w comment and the line
	---@type boolean
	padding = true,

	---Whether the cursor should stay at its position
	---NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
	---@type boolean
	sticky = true,

	---Lines to be ignored while comment/uncomment.
	---Could be a regex string or a function that returns a regex string.
	---Example: Use '^$' to ignore empty lines
	---@type string|fun():string
	ignore = nil,

	---LHS of toggle mappings in NORMAL + VISUAL mode
	---@type table
	toggler = {
		---Line-comment toggle keymap
		line = "gcc",
		block = "ъъ", -- disable
	},

	---LHS of operator-pending mappings in NORMAL + VISUAL mode
	---@type table
	opleader = {
		---Line-comment keymap
		line = "gc",
		block = "ъъ", --disable
	},

	---LHS of extra mappings
	---@type table
	extra = {
		---Add comment on the line above
		above = "gcO",
		---Add comment on the line below
		below = "gco",
		---Add comment at the end of line
		eol = "gcA",
	},

	---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
	---@type table
	mappings = {
		---Operator-pending mapping
		---Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
		---NOTE: These mappings can be changed individually by `opleader` and `toggler` config
		basic = true,
		---Extra mapping
		---Includes `gco`, `gcO`, `gcA`
		extra = true,
	},

	---Pre-hook, called before commenting the line
	---@type fun(ctx: Ctx):string
	pre_hook = function(ctx)
		-- Detemine whether to use linewise or blockwise commentstring
		local type = ctx.ctype == utils.ctype.line and "__default" or "__multiline"

		-- Determine the location where to calculate commentstring from
		local location = nil
		if ctx.ctype == utils.ctype.block then
			location = context.get_cursor_location()
		elseif ctx.cmotion == utils.cmotion.v or ctx.cmotion == utils.cmotion.V then
			location = context.get_visual_start_location()
		end

		return context_internal.calculate_commentstring({
			key = type,
			location = location,
		})
	end,

	---Post-hook, called after commenting is done
	---@type fun(ctx: Ctx)
	post_hook = nil,
})

-- gc = Comment

vim.keymap.set("n", "<leader>tc", function()
	toggling.toggle("auto_comment")
end, { silent = true, desc = "Toggle auto-Comment" })
toggling.register_initial("auto_comment", false)
toggling.register_description("auto_comment", "Auto-comment")
toggling.register_on_enable("auto_comment", function()
	vim.cmd([[set formatoptions+=cro]])
end)
toggling.register_on_disable("auto_comment", function()
	vim.cmd([[set formatoptions-=cro]])
end)
