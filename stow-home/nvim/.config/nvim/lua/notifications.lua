local function get_urgency(level)
    local levels = vim.log.levels
    if (level == levels.DEBUG) then
        return "low"
    elseif (level == levels.INFO) then
        return "normal"
    elseif (level == levels.WARN) then
        return "normal"
    elseif (level == levels.ERROR) then
        return "critical"
    elseif (level == levels.TRACE) then
        return "low"
    else
        local _ = level
        return "normal"
    end
end

local function log_level_to_string(level)
    local levels = vim.log.levels
    if (level == levels.DEBUG) then
        return "Debug"
    elseif (level == levels.INFO) then
        return "Info"
    elseif (level == levels.WARN) then
        return "Warn"
    elseif (level == levels.ERROR) then
        return "Error"
    elseif (level == levels.TRACE) then
        return "Trace"
    else
        local _ = level
        return "Info"
    end
end

local config = { command = "notify-send", icon = "nvim", app_name = "Neovim", hint = "string:desktop-entry:nvim", override_vim_notify = true }
local function on_cmd_exit(opts)
    if not (0 == opts.code) then
        return error(opts.stderr)
    else
        return nil
    end
end

local function send(msg, level, opts)
    if not (level == vim.log.levels.OFF) then
        local function _3_(...)
            local t_4_ = opts
            if (nil ~= t_4_) then
                t_4_ = t_4_.command
            else
            end
            return t_4_
        end
        local function _6_(...)
            local t_7_ = opts
            if (nil ~= t_7_) then
                t_7_ = t_7_.icon
            else
            end
            return t_7_
        end
        local function _9_(...)
            local t_10_ = opts
            if (nil ~= t_10_) then
                t_10_ = t_10_.app_name
            else
            end
            return t_10_
        end
        local function _12_(...)
            local t_13_ = opts
            if (nil ~= t_13_) then
                t_13_ = t_13_.hint
            else
            end
            return t_13_
        end
        vim.system(
            { (_3_() or config.command), log_level_to_string(level), msg, "--urgency", get_urgency(level), "--icon", (_6_() or config.icon),
                "--app-name", (_9_() or config.app_name),
                "--hint", (_12_() or config.hint) }, { text = true }, on_cmd_exit)
        return true
    else
        return nil
    end
end

local function setup(opts)
    vim.tbl_extend("force", config, (opts or {}))
    if config.override_vim_notify then
        vim["notify"] = send
        return nil
    else
        return nil
    end
end

return { send = send, setup = setup }
