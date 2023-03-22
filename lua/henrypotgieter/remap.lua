-- Set the leader
vim.g.mapleader = " "

-- Move lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Move forwards/backwards in searching
vim.keymap.set("n", "n", "nzzzv", { desc = "Search Next Item" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search Previous Item" })

-- vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer (linter)" })

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Quit all
vim.keymap.set("n", "<C-q>", "<cmd>qa<CR>", { desc = "[Q]uit All Buffers" })
vim.keymap.set("n", "<C-Q>", "<cmd>qa!<CR>", { desc = "[Q]uit All Buffers - Forced" })

-- Write the file
vim.keymap.set({ "n", "i", "v" }, "<C-z>", "<cmd>w<CR>", { desc = "Write Current Buffer" })

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "[S]earch and replace in file" }
)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR><CR>", { silent = true, desc = "Make file Executable" })

vim.keymap.set(
	"n",
	"<leader>po",
	"<cmd>e ~/.config/nvim/lua/henrypotgieter/packer.lua<CR>",
	{ desc = "Open packer config" }
)
vim.keymap.set(
	"n",
	"<leader>pm",
	"<cmd>e ~/.config/nvim/lua/henrypotgieter/keymap.lua<CR>",
	{ desc = "Open keymap config" }
)
vim.keymap.set("n", "<leader>pu", "<cmd>PackerSync<CR>", { desc = "Packer Update (Sync)" })
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open File List" })

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end, { desc = "Source current file into NVIM" })

-- Move Windows
vim.keymap.set("n", "<C-M-l>", "<C-w>l", { desc = "Move window right" })
vim.keymap.set("n", "<C-M-h>", "<C-w>h", { desc = "Move window left" })
vim.keymap.set("n", "<C-M-j>", "<C-w>j", { desc = "Move window down" })
vim.keymap.set("n", "<C-M-k>", "<C-w>k", { desc = "Move window up" })
vim.keymap.set("n", "<M-S-Right>", ":vertical resize -2<CR>", { desc = "Resize window right" })
vim.keymap.set("n", "<M-S-Left>", ":vertical resize +2<CR>", { desc = "Resize window left" })
vim.keymap.set("n", "<M-S-Down>", ":resize +2<CR>", { desc = "Resize window down" })
vim.keymap.set("n", "<M-S-Up>", ":resize -2<CR>", { desc = "Reise window up" })

-- Visual Stay in indent
vim.keymap.set("v", "<", "<gv", { desc = "Shit visual block left" })
vim.keymap.set("v", ">", ">gv", { desc = "Shit visual block left" })

-- Sort and Unique
vim.keymap.set("n", "<C-s>", "<cmd>%sort u<CR>", { desc = "Sort and Unique the buffer" })

--- GIT fugitive
-- vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git" })

-- NVIM Tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Open Nvim Tree" })

-- Toggles
vim.keymap.set("n", "<leader>tw", ":set wrap!<CR>", { desc = "Toggle Line Wrap" })
vim.keymap.set("n", "<leader>tp", ":set paste!<CR>", { desc = "Toggle Paste" })
vim.keymap.set("n", "<leader>ts", "<cmd>set spell!<CR>", { desc = "Toggle Spelling" })
vim.keymap.set("n", "<leader>tl", function()
	vim.cmd("ToggleDiag")
	vim.diagnostic.config({
		virtual_text = false,
	})
end, { desc = "Toggle LSP Diagnostics" })
vim.keymap.set("n", "<leader>tr", ":set relativenumber!<CR>", { desc = "Toggle Relativenumber" })
vim.keymap.set("n", "<leader>tn", ":set number!<CR>", { desc = "Toggle Number" })
vim.keymap.set("n", "<leader>tg", ":Gitsigns toggle_signs<CR>", { desc = "Toggle Gitsigns" })
vim.keymap.set("n", "<leader>th", ":set hls!<CR>", { desc = "Toggle Search Highlighting" })
vim.keymap.set("n", "<leader>tt", ":IndentBlanklineToggle<CR>", { desc = "Toggle Indent Blankline" })
vim.keymap.set("n", "<leader>ta", function()
	vim.cmd("IndentBlanklineToggle")
	vim.cmd("set relativenumber!")
	vim.cmd("set number!")
	vim.cmd("ToggleDiag")
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

vim.keymap.set("n", "<leader>te", function()
	if vim.g.toggles_visible then
		vim.g.toggles_visible = false
	else
		vim.g.toggles_visible = true
	end
end, { desc = "Toggles visibility" })

-- Change permissions of current file
vim.keymap.set("n", "<leader>pp", function()
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
			io.popen("chmod " .. input .. " " .. filename)
		end)
		print(" ") --[[ Clean the buffer so we don't see the prompt lingering after execution]]
	else
		print("Error - No matching file for permission change!")
	end
end, { desc = "Change File Permissions" })

-- Floaterm maps
vim.keymap.set(
	"n",
	"<leader>og",
	":FloatermNew --title=LazyGit lazygit<CR>",
	{ desc = "LazyGit", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>oc",
	":FloatermNew --title=Qalc qalc<CR>",
	{ desc = "Qalc", noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>om", function()
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

-- Nerd Comment Keys
vim.keymap.set("n", "<leader>cc", ':call nerdcommenter#Comment("n", "Comment")<CR>', { desc = "comment" })
vim.keymap.set("n", "<leader>cs", ':call nerdcommenter#Comment("n", "Sexy")<CR>', { desc = "comment sexy" })
vim.keymap.set("n", "<leader>cn", ':call nerdcommenter#Comment("n","Nested")<CR>', { desc = "comment nested" })
vim.keymap.set("n", "<leader>cm", ':call nerdcommenter#Comment("n","Minimal")<CR>', { desc = "comment minimal" })
vim.keymap.set("n", "<leader>cy", ':call nerdcommenter#Comment("n","Yank")<CR>', { desc = "comment yank" })
vim.keymap.set("n", "<leader>cl", ':call nerdcommenter#Comment("n","AlignLeft")<CR>', { desc = "comment align left" })
vim.keymap.set("n", "<leader>cb", ':call nerdcommenter#Comment("n","AlignBoth")<CR>', { desc = "comment align both" })
vim.keymap.set("n", "<leader>ci", ':call nerdcommenter#Comment("n","Invert")<CR>', { desc = "comment invert" })
vim.keymap.set("n", "<leader>cA", ':call nerdcommenter#Comment("n","Append")<CR>', { desc = "comment append" })
vim.keymap.set("n", "<leader>ca", ':call nerdcommenter#Comment("n","AltDelims")<CR>', { desc = "comment alt delims" })
vim.keymap.set("n", "<leader>cu", ':call nerdcommenter#Comment("n","Uncomment")<CR>', { desc = "uncomment" })
vim.keymap.set("n", "<leader>c$", ':call nerdcommenter#Comment("n","ToEOL")<CR>', { desc = "comment to eol" })
vim.keymap.set("n", "<leader>c<space>", ':call nerdcommenter#Comment("n","Toggle")<CR>', { desc = "comment toggle" })
vim.keymap.set("n", "<leader>cp", '{jV}k:call nerdcommenter#Comment("n","Sexy")<CR>', { desc = "comment paragraph" })

vim.keymap.set("x", "<leader>cc", ':call nerdcommenter#Comment("x", "Comment")<CR>', { desc = "comment" })
vim.keymap.set("x", "<leader>cs", ':call nerdcommenter#Comment("x", "Sexy")<CR>', { desc = "comment sexy" })
vim.keymap.set("x", "<leader>cn", ':call nerdcommenter#Comment("x","Nested")<CR>', { desc = "comment nested" })
vim.keymap.set("x", "<leader>cm", ':call nerdcommenter#Comment("x","Minimal")<CR>', { desc = "comment minimal" })
vim.keymap.set("x", "<leader>cy", ':call nerdcommenter#Comment("x","Yank")<CR>', { desc = "comment yank" })
vim.keymap.set("x", "<leader>cl", ':call nerdcommenter#Comment("x","AlignLeft")<CR>', { desc = "comment align left" })
vim.keymap.set("x", "<leader>cb", ':call nerdcommenter#Comment("x","AlignBoth")<CR>', { desc = "comment align both" })
vim.keymap.set("x", "<leader>ci", ':call nerdcommenter#Comment("x","Invert")<CR>', { desc = "comment invert" })
vim.keymap.set("x", "<leader>cA", ':call nerdcommenter#Comment("x","Append")<CR>', { desc = "comment append" })
vim.keymap.set("x", "<leader>ca", ':call nerdcommenter#Comment("x","AltDelims")<CR>', { desc = "comment alt delims" })
vim.keymap.set("x", "<leader>cu", ':call nerdcommenter#Comment("x","Uncomment")<CR>', { desc = "uncomment" })
vim.keymap.set("x", "<leader>c$", ':call nerdcommenter#Comment("x","ToEOL")<CR>', { desc = "comment to eol" })
vim.keymap.set("x", "<leader>c<space>", ':call nerdcommenter#Comment("x","Toggle")<CR>', { desc = "comment toggle" })
