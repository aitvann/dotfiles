local M = {}

M.initials = {}
M.descriptions = {}
M.on_enable_hooks = {}
M.on_disable_hooks = {}

local function make_sure_init()
	if vim.b.toggles == nil then
		vim.cmd([[let b:toggles = {}]])
		for toggle_name, initial in pairs(M.initials) do
			if initial then
				M.call_on_enable_hook(toggle_name)
			else
				M.call_on_disable_hook(toggle_name)
			end

			local vim_initial = initial and 1 or 0
			local expr = "let b:toggles." .. toggle_name .. " = " .. vim_initial
			vim.cmd(expr)
		end
	end
end

M.is_enabled = function(toggle_name)
	make_sure_init()
	local enabled = vim.api.nvim_eval('get(b:toggles,"' .. toggle_name .. '")')
	return enabled ~= 0 and true or false
end

M.enable = function(toggle_name)
	make_sure_init()
	vim.cmd("let b:toggles." .. toggle_name .. " = 1")
	M.call_on_enable_hook(toggle_name)
	print(M.get_description(toggle_name) .. " enabled")
end

M.disable = function(toggle_name)
	make_sure_init()
	vim.cmd("let b:toggles." .. toggle_name .. " = 0")
	M.call_on_disable_hook(toggle_name)
	print(M.get_description(toggle_name) .. " disabled")
end

M.toggle = function(toggle_name)
	if M.is_enabled(toggle_name) then
		M.disable(toggle_name)
	else
		M.enable(toggle_name)
	end
end

M.register_initial = function(toggle_name, initial)
	if M.initials[toggle_name] ~= nil then
		print("Warn: " .. toggle_name .. " initial overrided")
	end

	M.initials[toggle_name] = initial
end

M.get_description = function(toggle_name)
	local desc = M.descriptions[toggle_name]
	return desc ~= nil and desc or toggle_name
end

M.register_description = function(toggle_name, description)
	if M.descriptions[toggle_name] ~= nil then
		print("Warn: " .. toggle_name .. " description overrided")
	end

	M.descriptions[toggle_name] = description
end

M.register_on_enable = function(toggle_name, hook)
	if M.on_disable_hooks[toggle_name] ~= nil then
		print("Warn: " .. toggle_name .. " on_enable hook overrided")
	end

	M.on_enable_hooks[toggle_name] = hook
end

M.register_on_disable = function(toggle_name, hook)
	if M.on_disable_hooks[toggle_name] ~= nil then
		print("Warn: " .. toggle_name .. " on_disable hook overrided")
	end

	M.on_disable_hooks[toggle_name] = hook
end

M.call_on_enable_hook = function(toggle_name)
	local hook = M.on_enable_hooks[toggle_name]
	if hook ~= nil then
		hook()
	end
end

M.call_on_disable_hook = function(toggle_name)
	local hook = M.on_disable_hooks[toggle_name]
	if hook ~= nil then
		hook()
	end
end

-- <leader>t = Toggling

return M
