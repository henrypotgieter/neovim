-- This file can be loaded by calling `lua require('plugins')` from your init.vim
--
local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	use("wbthomason/packer.nvim") -- Packer
	use({ "nvim-lua/plenary.nvim" }) -- Useful lua functions used by lots of plugins
	use({ "windwp/nvim-autopairs" }) -- Autopairs, integrates with both cmp and treesitter
	use({ "numToStr/Comment.nvim" }) -- Comment enhancements
	use({ "JoosepAlviste/nvim-ts-context-commentstring" }) -- Comment enhancements

	-- Lua Dev
	use({ "rafcamlet/nvim-luapad" })

	-- NVIM Tree file manager
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
		tag = "nightly", -- optional, updated every week. (see issue #1193)
	})

	-- Telescope FuzzyFinder Tool
	use({ "nvim-telescope/telescope.nvim" })

	-- Dark colour pallet and custom colour settings
	use({ "nxvu699134/vn-night.nvim" })

	-- Fugitive
	use({ "tpope/vim-fugitive" })

	-- Dev icons
	use({ "romgrk/barbar.nvim", requires = "nvim-web-devicons" })

	-- Completion stuff
	use({ "hrsh7th/nvim-cmp" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer" }) -- buffer completions use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lua" })

	-- Snippets
	use({ "L3MON4D3/LuaSnip" }) --snippet engine
	use({ "rafamadriz/friendly-snippets" }) -- a bunch of snippets to use
	use({ "honza/vim-snippets" })

	-- Cheat.sh
	use({ "dbeniamine/cheat.sh-vim" })

	-- LSP
	use({ "neovim/nvim-lspconfig" })
	use({ "williamboman/mason.nvim" }) -- simple to use language server installer
	use({ "williamboman/mason-lspconfig.nvim" })
	use({ "RRethy/vim-illuminate" })
	use({ "b0o/schemastore.nvim" })
	use({ "jose-elias-alvarez/null-ls.nvim" })
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	use({ "HiPhish/nvim-ts-rainbow2" })

	-- File jumping within a project
	use({ "theprimeagen/harpoon" })

	-- Useful undotree tool (doesn't require git)
	use({ "mbbill/undotree" })

	-- Commenting
	use({ "preservim/nerdcommenter" })

	-- Diagnostics
	use({ "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim" })

	-- Custom statusbar from feline
	use({ "henrypotgieter/feline.nvim" })

	-- Indent markers
	use({ "lukas-reineke/indent-blankline.nvim" })

	-- Debugging
	use({ "mfussenegger/nvim-dap" })
	use({ "mfussenegger/nvim-dap-python" })
	use({ "leoluz/nvim-dap-go" })
	use({ "rcarriga/nvim-dap-ui" })
	use({ "theHamsta/nvim-dap-virtual-text" })
	use({ "nvim-telescope/telescope-dap.nvim" })

	-- Git
	use({ "lewis6991/gitsigns.nvim" })

	-- Folding
	use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })

	-- Floating Terminals
	use({ "voldikss/vim-floaterm" })

	use({
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
