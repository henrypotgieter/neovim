require("vn-night").setup()

function ColorThings(color)
	color = color or "vn-night"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "LineNr", { fg = "#5FeFF0", bg = "#400f0a" })
	vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#AFFF70" })
	vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#AFFF70" })
	vim.api.nvim_set_hl(0, "Folded", { fg = "#AFFF70", bg = "#000F5F" })
	vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#8FcF60" })
	vim.api.nvim_set_hl(0, "Comment", { fg = "#3F9F20" })
end

ColorThings()

-- sdfkj
