local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	border = nil,
	cmd = { "nvim" },
	debounce = 250,
	default_timeout = 5000,
	diagnostic_config = nil,
	diagnostics_format = "[null-ls] #{c} #{m}",
	fallback_severity = vim.diagnostic.severity.ERROR,
	log_level = "warn",
	notify_format = "[null-ls] %s",
	on_attach = nil,
	on_init = nil,
	on_exit = nil,
	root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git"),
	should_attach = nil,
	temp_dir = nil,
	update_in_insert = false,
	debug = false,
	sources = {
		formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,
		formatting.shfmt,
		formatting.shellharden,
		diagnostics.flake8.with({ extra_args = { "--max-line-length=89", "--ignore=E117", "--ignore=W503", "--ignore=E501" } }),
		diagnostics.jsonlint,
	},
})
