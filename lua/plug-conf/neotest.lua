local status_ok, _ = pcall(require, "neotest")
if not status_ok then
    require("util.notify").notify("cannot load plugin neotest","error","Plugin")
	return
end

local M = {}

local function config_neotest(config)
	config.setup({
		adapters = {
			require("neotest-rust"),
			require("neotest-go")({
				experimental = {
					test_table = true,
				},
			}),
		},
	})
end

function M.setup()
	config_neotest(require("neotest"))
end

return M
