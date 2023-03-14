require("gitsigns").setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = " --- <author>, <author_time:%Y-%m-%d> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	yadm = {
		enable = false,
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Gitsigns stage hunk" })
		map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Gitsigns reset hunk" })
		map("n", "<leader>hS", gs.stage_buffer, { desc = "Gitsigns stage buffer" })
		map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Gitsigns undo stage hunk" })
		map("n", "<leader>hR", gs.reset_buffer, { desc = "Gitsigns reset buffer" })
		map("n", "<leader>hp", gs.preview_hunk, { desc = "Gitsigns preview hunk" })
		map("n", "<leader>hb", function()
			gs.blame_line({ full = true })
		end, { desc = "Gitsigns blame" })
		map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Gitsigns toggle blame" })
		map("n", "<leader>hd", gs.diffthis, { desc = "Gitsigns diff" })
		map("n", "<leader>hD", function()
			gs.diffthis("~")
		end)
		map("n", "<leader>td", gs.toggle_deleted, { desc = "Gitsigns toggled deleted" })

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns select hunk" })
	end,
})
