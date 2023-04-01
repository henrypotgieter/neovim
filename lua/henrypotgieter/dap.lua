require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

--[[
   [local dap = require("dap")
   [dap.adapters.python = {
   [    type = "executable",
   [    command = "~/.virtualenvs/debugpy/bin/python",
   [    args = { "-m", "debugpy.adapter" },
   [}
   [dap.configurations.python = {
   [    {
   [        -- The first three options are required by nvim-dap
   [        type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
   [        request = "launch",
   [        name = "Launch file",
   [
   [        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
   [
   [        program = "${file}", -- This configuration will launch the current file if used.
   [        pythonPath = function()
   [            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
   [            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
   [            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
   [            local cwd = vim.fn.getcwd()
   [            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
   [                return cwd .. "/venv/bin/python"
   [            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
   [                return cwd .. "/.venv/bin/python"
   [            else
   [                return "/usr/bin/python"
   [            end
   [        end,
   [    },
   [}
   ]]

local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

require("nvim-dap-virtual-text").setup()
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

vim.keymap.set("n", "<F5>", function()
	--require("dapui").open()
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
vim.keymap.set("n", "<Leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "<Leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input('Breadpoint condition: '))
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

--[[
   [nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR>
   [nnoremap <silent> <leader>df :lua require('dap-python').test_class()<CR>
   [vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>
   ]]
