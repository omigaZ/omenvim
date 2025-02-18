local status_ok, _ = pcall(require, "smoothcursor")
if not status_ok then
	require("utils.notify").notify("smoothcursor not found!", "error", "Plugin")
	return
end

local M = {}

local function config_smoothcursor(smoothcursor)
	smoothcursor.setup({
		autostart = true,
		cursor = "", -- cursor shape (need nerd font)
		texthl = "SmoothCursor", -- highlight group, default is { bg = nil, fg = "#FFD400" }
		linehl = nil, -- highlight sub-cursor line like 'cursorline', "CursorLine" recommended
		type = "default", -- define cursor movement calculate function, "default" or "exp" (exponential).
		fancy = {
			enable = true, -- enable fancy mode
			-- head = { cursor = "▷", texthl = "SmoothCursorRed", linehl = nil },
			head = { cursor = "▷", texthl = "SmoothCursorYellow", linehl = nil },
			body = {
				{ cursor = "", texthl = "SmoothCursorRed" },
				{ cursor = "", texthl = "SmoothCursorOrange" },
				{ cursor = "●", texthl = "SmoothCursorYellow" },
				{ cursor = "●", texthl = "SmoothCursorGreen" },
				{ cursor = "•", texthl = "SmoothCursorAqua" },
				{ cursor = ".", texthl = "SmoothCursorBlue" },
				{ cursor = ".", texthl = "SmoothCursorPurple" },
			},
			tail = { cursor = nil, texthl = "SmoothCursor" },
		},
		flyin_effect = nil, -- "bottom" or "top"
		speed = 25, -- max is 100 to stick to your current position
		intervals = 35, -- tick interval
		priority = 10, -- set marker priority
		timeout = 3000, -- timout for animation
		threshold = 3, -- animate if threshold lines jump
		disable_float_win = false, -- disable on float window
		enabled_filetypes = nil, -- example: { "lua", "vim" }
		disabled_filetypes = nil, -- this option will be skipped if enabled_filetypes is set. example: { "TelescopePrompt", "NvimTree" }
	})
end

function M.setup()
	config_smoothcursor(require("smoothcursor"))
end

return M
