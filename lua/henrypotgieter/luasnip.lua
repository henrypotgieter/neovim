local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.set_config({
	-- THis tells LuaSnip to remember to keep around the laest snippet.
	-- You can jump back into it even if you move outside of the selection
	history = true,

	-- This one is cool cause if you ahve dynamic snippets, it updates as you type!
	updateevents = "TextChanged,TextChangedI",

	-- Autosnippets
	enable_autosnippets = true,

	-- Crazy Highlights
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "<", "Error" } },
			},
		},
	},
})
vim.keymap.set({ "s", "i" }, "<C-f>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true, desc = "Expand or Jump Snippet" })

vim.keymap.set({ "i", "s" }, "<C-b>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true, desc = "Jump Back Snippet" })

vim.keymap.set("i", "<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { desc = "Select within list of options" })

vim.keymap.set(
	"n",
	"<leader><leader>s",
	"<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>",
	{ desc = "Source Luasnip file" }
)

local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet

local date = function()
	return { os.date("%Y-%m-%d") }
end

local wkst = function(arg)
	local handle = io.popen("/usr/bin/python ~/.config/nvim/extras/wkst.py " .. arg)
	local result = handle:read("*a")
	handle:close()
	return result:sub(1, -2)
end

ls.add_snippets(nil, {
	all = {
		s({
			trig = "rc",
			namr = "Radius Client",
			dscr = "Radius Client Entry",
		}, {
			t({ "client " }),
			i(1, "IPADDR"),
			t({ " {", "    shortname = " }),
			i(2, "SHORTNAME PREFIX"),
			t("-"),
			rep(1),
			t({ "", "    secret = " }),
			i(3, "SECRET"),
			t({ "", "    ipaddr = " }),
			rep(1),
			t({ "", "}" }),
			i(4),
		}),
		s({
			trig = "wkst",
			namr = "Week Status",
			dscr = "Create weekly status template",
		}, {
			t({
				"***********************************",
				"*    Task Tracking for Week Of    *",
				"",
			}),
			t("*     "),
			f(function()
				local result = wkst(1)
				return result
			end),
			t(" - "),
			f(function()
				local result = wkst(2)
				return result
			end),
			t({ "     *", "***********************************" }),
			t({ "", "", "Monday    - " }),
			f(function()
				local result = wkst(1)
				return result
			end),
			t({ "", "", "" }),
			i(0),
			t({ "", "", "Tuesday   - " }),
			f(function()
				local result = wkst(2)
				return result
			end),
			t({ "", "", "", "Wednesday - " }),
			f(function()
				local result = wkst(3)
				return result
			end),
			t({ "", "", "", "Thursday  - " }),
			f(function()
				local result = wkst(4)
				return result
			end),
			t({ "", "", "", "Friday    - " }),
			f(function()
				local result = wkst(5)
				return result
			end),
			t({ "", "", "" }),
		}),
	},
})
