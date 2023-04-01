local dap, dapui = require("dap"), require("dapui")

-- Trigger dapui to open/close dynamically
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- Set some custom icons
vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "💬", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "👺", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "🪵", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "😠", texthl = "", linehl = "", numhl = "" })

-- Enable virtual text
require("nvim-dap-virtual-text").setup()

-- More DAPUI setup options
dapui.setup({
	icons = {
		expanded = "⯆",
		collapsed = "⯈",
		circular = "↺",
		current_frame = "",
	},
	mappings = {
		expand = "<CR>",
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},

	layouts = {
		{
			elements = {
				{
					id = "scopes",
					size = 0.25,
				},
				{
					id = "breakpoints",
					size = 0.25,
				},
				{
					id = "stacks",
					size = 0.25,
				},
				{
					id = "watches",
					size = 0.25,
				},
			},
			position = "left",
			size = 90,
		},
		{
			elements = {
				{
					id = "repl",
					size = 0.5,
				},
				{
					id = "console",
					size = 0.5,
				},
			},
			position = "bottom",
			size = 10,
		},
	},
	controls = {
		element = "repl",
		enabled = true,
		icons = {
			disconnect = "",
			pause = "",
			play = "契",
			run_last = "ﬀ",
			step_back = "社",
			step_into = "",
			step_out = "",
			step_over = "祝",
			terminate = "",
		},
	},
	render = {
		indent = 1,
		max_value_lines = 100,
	},
})

-- Keymaps!
vim.keymap.set("n", "<F5>", function()
	require("dap").continue()
end, { desc = "DAP Continue" })

vim.keymap.set("n", "<F6>", function()
	require("dap").step_over()
end, { desc = "DAP Step Over" })

vim.keymap.set("n", "<F7>", function()
	require("dap").step_into()
end, { desc = "DAP Step Into" })

vim.keymap.set("n", "<F8>", function()
	require("dap").step_out()
end, { desc = "DAP Step Out" })

vim.keymap.set("n", "<F10>", function()
	require("dap").disconnect()
	require("dap").close()
	require("dapui").close()
end, { desc = "DAP Disconnect/Close" })

vim.keymap.set("n", "<Leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })

vim.keymap.set("n", "<Leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("Breadpoint condition: "))
end, { desc = "DAP Set Breakpoint Condition" })

vim.keymap.set("n", "<Leader>dp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "DAP Set Breapoint" })

vim.keymap.set("n", "<Leader>dr", function()
	require("dap").repl.open()
end, { desc = "DAP Repl Open" })

vim.keymap.set("n", "<Leader>dl", function()
	require("dap").run_last()
end, { desc = "DAP RUN Last" })

vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end, { desc = "DAP UI Hover" })

vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
	require("dap.ui.widgets").preview()
end, { desc = "DAP UI Preview" })

vim.keymap.set("n", "<Leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end, { desc = "DAP Frames" })

vim.keymap.set("n", "<Leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end, { desc = "DAP Scopes" })

vim.keymap.set("n", "<Leader>dm", function()
	require("dap-python").test_method()
end, { desc = "DAP Test Method" })

vim.keymap.set("n", "<Leader>dc", function()
	require("dap-python").test_class()
end, { desc = "DAP Test Class" })

vim.keymap.set("v", "<Leader>ds", function()
	require("dap-python").debug_selection()
end, { desc = "DAP Debug Selection" })
-- Go debugging adapter:

dap.adapters.delve = {
	type = "server",
	port = "${port}",
	executable = {
		command = "dlv",
		args = { "dap", "-l", "127.0.0.1:${port}" },
	},
}

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
	{
		type = "delve",
		name = "Debug",
		request = "launch",
		program = "${file}",
	},
	{
		type = "delve",
		name = "Debug test", -- configuration for debugging test files
		request = "launch",
		mode = "test",
		program = "${file}",
	},
	-- works with go.mod packages and sub packages
	{
		type = "delve",
		name = "Debug test (go.mod)",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	},
}

-- Bash debug adapator (mason)
dap.adapters.bashdb = {
	type = "executable",
	command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
	name = "bashdb",
}
dap.configurations.sh = {
	{
		type = "bashdb",
		request = "launch",
		name = "Launch file",
		showDebugOutput = true,
		pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
		pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
		trace = true,
		file = "${file}",
		program = "${file}",
		cwd = "${workspaceFolder}",
		pathCat = "cat",
		pathBash = "/bin/bash",
		pathMkfifo = "mkfifo",
		pathPkill = "pkill",
		args = {},
		env = {},
		terminalKind = "integrated",
	},
}
