-- Set up nvim-cmp.
--local cmp_status_ok, cmp = require('cmp')
local cmp_status_ok, cmp = pcall(require, "cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

require("luasnip/loaders/from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({
	paths = "~/.local/share/nvim/site/pack/packer/start/vim-snippets/snippets",
})

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

--   פּ ﯟ   some other good icons
local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		--[[        -- Removed as it seems that supertab malfunctions at inopportune times
		   [["<C-Tab>"] = cmp.mapping(function(fallback)
		   [    if cmp.visible() then
		   [        cmp.select_next_item()
		   [    elseif luasnip.expandable() then
		   [        luasnip.expand()
		   [    elseif luasnip.expand_or_jumpable() then
		   [        luasnip.expand_or_jump()
		   [    elseif check_backspace() then
		   [        fallback()
		   [    else
		   [        fallback()
		   [    end
		   [end, {
		   [    "i",
		   [    "s",
		   [}),
		   [["<S-Tab>"] = cmp.mapping(function(fallback)
		   [    if cmp.visible() then
		   [        cmp.select_prev_item()
		   [    elseif luasnip.jumpable(-1) then
		   [        luasnip.jump(-1)
		   [    else
		   [        fallback()
		   [    end
		   [end, {
		   [    "i",
		   [    "s",
		   [}),
           ]]
	}),
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				--       jedi_language_server = "[Jedi]",
				luasnip = "[Luasnip]",
				nvim_lsp = "[Nvim_LSP]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = cmp.config.sources({
		--{ name = 'jedi_language_server' },
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	}),
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline(":", {
	sources = {
		{
			name = "cmdline",
			option = {
				ignore_cmds = {},
			},
		},
	},
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig")["jedi_language_server"].setup({
	capabilities = capabilities,
})

capabilities.textDocument.completion.completionItem.snippetSupport = true
require("lspconfig")["jsonls"].setup({
	capabilities = capabilities,
})
