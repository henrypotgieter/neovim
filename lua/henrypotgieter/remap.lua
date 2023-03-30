local k = vim.keymap

-- Set the leader
vim.g.mapleader = " "

-- Move lines up/down in visual mode
k.set("v", "J", ":m '>+1<CR>gv=gv")
k.set("v", "K", ":m '<-2<CR>gv=gv")

k.set("n", "J", "mzJ`z")
k.set("n", "<C-d>", "<C-d>zz")
k.set("n", "<C-u>", "<C-u>zz")

-- Move forwards/backwards in searching
k.set("n", "n", "nzzzv", { desc = "Search Next Item" })
k.set("n", "N", "Nzzzv", { desc = "Search Previous Item" })

-- k.set("n", "Q", "<nop>")
k.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
k.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer (linter)" })

k.set("n", "<C-k>", "<cmd>cnext<CR>zz")
k.set("n", "<C-j>", "<cmd>cprev<CR>zz")
k.set("n", "<leader>k", "<cmd>lnext<CR>zz")
k.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Quit all
k.set("n", "<C-q>", "<cmd>qa<CR>", { desc = "[Q]uit All Buffers" })
k.set("n", "<C-Q>", "<cmd>qa!<CR>", { desc = "[Q]uit All Buffers - Forced" })

-- Write the file
k.set({ "n", "i", "v" }, "<C-z>", "<cmd>w<CR>", { desc = "Write Current Buffer" })

k.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "[S]earch and replace in file" }
)
k.set("n", "<leader>x", "<cmd>!chmod +x %<CR><CR>", { silent = true, desc = "Make file Executable" })

k.set("n", "<leader>po", "<cmd>e ~/.config/nvim/lua/henrypotgieter/packer.lua<CR>", { desc = "Open packer config" })
k.set("n", "<leader>pm", "<cmd>e ~/.config/nvim/lua/henrypotgieter/keymap.lua<CR>", { desc = "Open keymap config" })
k.set("n", "<leader>pu", "<cmd>PackerSync<CR>", { desc = "Packer Update (Sync)" })
k.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open File List" })

k.set("n", "<leader><leader>", function()
	vim.cmd("so")
end, { desc = "Source current file into NVIM" })

-- Move Windows
k.set("n", "<C-M-l>", "<C-w>l", { desc = "Move window right" })
k.set("n", "<C-M-h>", "<C-w>h", { desc = "Move window left" })
k.set("n", "<C-M-j>", "<C-w>j", { desc = "Move window down" })
k.set("n", "<C-M-k>", "<C-w>k", { desc = "Move window up" })
k.set("n", "<M-S-Right>", ":vertical resize -2<CR>", { desc = "Resize window right" })
k.set("n", "<M-S-Left>", ":vertical resize +2<CR>", { desc = "Resize window left" })
k.set("n", "<M-S-Down>", ":resize +2<CR>", { desc = "Resize window down" })
k.set("n", "<M-S-Up>", ":resize -2<CR>", { desc = "Reise window up" })

-- Visual Stay in indent
k.set("v", "<", "<gv", { desc = "Shit visual block left" })
k.set("v", ">", ">gv", { desc = "Shit visual block left" })

-- Sort and Unique
k.set("n", "<C-s>", "<cmd>%sort u<CR>", { desc = "Sort and Unique the buffer" })

--- GIT fugitive
-- k.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git" })

-- NVIM Tree
k.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Open Nvim Tree" })

-- Toggles
k.set("n", "<leader>tw", ":set wrap!<CR>", { desc = "Toggle Line Wrap" })
k.set("n", "<leader>tp", ":set paste!<CR>", { desc = "Toggle Paste" })
k.set("n", "<leader>ts", "<cmd>set spell!<CR>", { desc = "Toggle Spelling" })
k.set("n", "<leader>tl", function()
	vim.cmd("ToggleDiag")
	vim.diagnostic.config({
		virtual_text = false,
	})
end, { desc = "Toggle LSP Diagnostics" })
k.set("n", "<leader>tr", ":set relativenumber!<CR>", { desc = "Toggle Relativenumber" })
k.set("n", "<leader>tn", ":set number!<CR>", { desc = "Toggle Number" })
k.set("n", "<leader>tg", ":Gitsigns toggle_signs<CR>", { desc = "Toggle Gitsigns" })
k.set("n", "<leader>th", ":set hls!<CR>", { desc = "Toggle Search Highlighting" })
k.set("n", "<leader>tt", ":IndentBlanklineToggle<CR>", { desc = "Toggle Indent Blankline" })
k.set("n", "<leader>ta", function()
	vim.cmd("IndentBlanklineToggle")
	vim.cmd("set relativenumber!")
	vim.cmd("set number!")
	vim.cmd("ToggleDiag")
	vim.diagnostic.config({
		virtual_text = false,
		float = false,
	})
	vim.cmd("Gitsigns toggle_current_line_blame")
	-- Only toggle gitsigns if we appear to be looking at a file (otherwise errors ensue)
	if vim.fn.expand("%:t"):len() > 0 then
		vim.cmd("Gitsigns toggle_signs")
	end
	if vim.o.foldcolumn == "0" then
		vim.o.foldcolumn = "1"
		vim.cmd("set scl=yes")
	else
		vim.o.foldcolumn = "0"
		vim.cmd("set scl=no")
	end
end, { desc = "Toggle all decorations/nums" })

k.set("n", "<leader>te", function()
	if vim.g.toggles_visible then
		vim.g.toggles_visible = false
	else
		vim.g.toggles_visible = true
	end
end, { desc = "Toggles visibility" })

-- Change permissions of current file
k.set("n", "<leader>pp", function()
	local function file_exists(name)
		local f = io.open(name, "r")
		if f ~= nil then
			io.close(f)
			return true
		else
			return false
		end
	end
	local filename = vim.api.nvim_buf_get_name(0)
	if filename and file_exists(vim.fn.expand("%")) then
		vim.ui.input({ prompt = " ****** Enter desired file permissions to set: " }, function(input)
			local result = io.popen("chmod " .. input .. " " .. filename .. " 2>/dev/null || echo fail")
			if result and result:read() == "fail" then
				print("Bad input, no permissions change made.")
			else
				print(" ") --[> Clean the buffer so we don't see the prompt lingering after execution<]
			end
		end)
	else
		print("Error - No matching file for permission change!")
	end
end, { desc = "Change File Permissions" })

-- Floaterm maps
k.set(
	"n",
	"<leader>og",
	":FloatermNew --title=LazyGit lazygit<CR>",
	{ desc = "LazyGit", noremap = true, silent = true }
)
k.set("n", "<leader>oc", ":FloatermNew --title=Qalc qalc<CR>", { desc = "Qalc", noremap = true, silent = true })
k.set("n", "<leader>om", function()
	-- You need glow for this to work:  https://github.com/charmbracelet/glow
	local function file_exists(name)
		local f = io.open(name, "r")
		if f ~= nil then
			io.close(f)
			return true
		else
			return false
		end
	end
	local filename = vim.api.nvim_buf_get_name(0)
	-- Check if the file exists and if it looks like a markdown file
	if filename:match(".*%.[Mm][Dd]$") and file_exists(vim.fn.expand("%")) then
		vim.cmd("FloatermNew --title=Glow glow -p " .. filename)
	else
		print("Error - File not written to disk or doesn't appear to be a .md!")
	end
end, { desc = "Glow (Markdown)", noremap = true, silent = true })

k.set("n", "<leader>d", ":%s/ *$//<CR>", { desc = "Delete trailing spaces" })

-- Nerd Comment Keys
k.set("n", "<leader>cc", ':call nerdcommenter#Comment("n", "Comment")<CR>', { desc = "comment" })
k.set("n", "<leader>cs", ':call nerdcommenter#Comment("n", "Sexy")<CR>', { desc = "comment sexy" })
k.set("n", "<leader>cn", ':call nerdcommenter#Comment("n","Nested")<CR>', { desc = "comment nested" })
k.set("n", "<leader>cm", ':call nerdcommenter#Comment("n","Minimal")<CR>', { desc = "comment minimal" })
k.set("n", "<leader>cy", ':call nerdcommenter#Comment("n","Yank")<CR>', { desc = "comment yank" })
k.set("n", "<leader>cl", ':call nerdcommenter#Comment("n","AlignLeft")<CR>', { desc = "comment align left" })
k.set("n", "<leader>cb", ':call nerdcommenter#Comment("n","AlignBoth")<CR>', { desc = "comment align both" })
k.set("n", "<leader>ci", ':call nerdcommenter#Comment("n","Invert")<CR>', { desc = "comment invert" })
k.set("n", "<leader>cA", ':call nerdcommenter#Comment("n","Append")<CR>', { desc = "comment append" })
k.set("n", "<leader>ca", ':call nerdcommenter#Comment("n","AltDelims")<CR>', { desc = "comment alt delims" })
k.set("n", "<leader>cu", ':call nerdcommenter#Comment("n","Uncomment")<CR>', { desc = "uncomment" })
k.set("n", "<leader>c$", ':call nerdcommenter#Comment("n","ToEOL")<CR>', { desc = "comment to eol" })
k.set("n", "<leader>c<space>", ':call nerdcommenter#Comment("n","Toggle")<CR>', { desc = "comment toggle" })
k.set("n", "<leader>cp", '{jV}k:call nerdcommenter#Comment("n","Sexy")<CR>', { desc = "comment paragraph" })

k.set("x", "<leader>cc", ':call nerdcommenter#Comment("x", "Comment")<CR>', { desc = "comment" })
k.set("x", "<leader>cs", ':call nerdcommenter#Comment("x", "Sexy")<CR>', { desc = "comment sexy" })
k.set("x", "<leader>cn", ':call nerdcommenter#Comment("x","Nested")<CR>', { desc = "comment nested" })
k.set("x", "<leader>cm", ':call nerdcommenter#Comment("x","Minimal")<CR>', { desc = "comment minimal" })
k.set("x", "<leader>cy", ':call nerdcommenter#Comment("x","Yank")<CR>', { desc = "comment yank" })
k.set("x", "<leader>cl", ':call nerdcommenter#Comment("x","AlignLeft")<CR>', { desc = "comment align left" })
k.set("x", "<leader>cb", ':call nerdcommenter#Comment("x","AlignBoth")<CR>', { desc = "comment align both" })
k.set("x", "<leader>ci", ':call nerdcommenter#Comment("x","Invert")<CR>', { desc = "comment invert" })
k.set("x", "<leader>cA", ':call nerdcommenter#Comment("x","Append")<CR>', { desc = "comment append" })
k.set("x", "<leader>ca", ':call nerdcommenter#Comment("x","AltDelims")<CR>', { desc = "comment alt delims" })
k.set("x", "<leader>cu", ':call nerdcommenter#Comment("x","Uncomment")<CR>', { desc = "uncomment" })
k.set("x", "<leader>c$", ':call nerdcommenter#Comment("x","ToEOL")<CR>', { desc = "comment to eol" })
k.set("x", "<leader>c<space>", ':call nerdcommenter#Comment("x","Toggle")<CR>', { desc = "comment toggle" })
