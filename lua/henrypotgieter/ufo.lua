local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = ("  %d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, "MoreMsg" })
	return newVirtText
end

require("ufo").setup({
	fold_virt_text_handler = handler,
	-- provider_selector = function(bufnr, filetype, buftype)
	provider_selector = function()
		return { "treesitter", "indent" }
	end,
})

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99  -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- UFO Folding neatness
vim.keymap.set("n", "zK", function()
	require("ufo").goPreviousClosedFold()
	require("ufo").peekFoldedLinesUnderCursor()
end, { desc = "Goto Previous Fold and Peek" })
vim.keymap.set("n", "zJ", function()
	require("ufo").goNextClosedFold()
	require("ufo").peekFoldedLinesUnderCursor()
end, { desc = "Goto Next Fold and Peek" })
vim.keymap.set("n", "zs", function()
	require("ufo").peekFoldedLinesUnderCursor()
end, { desc = "Peek Folded Lines" })

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open All Folds" })
vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
vim.keymap.set("n", "zK", function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		-- choose one of coc.nvim and nvim lsp
		vim.fn.CocActionAsync("definitionHover") -- coc.nvim
		vim.lsp.buf.hover()
	end
end, { desc = "Peek folded lines" })

-- Build a toggle keymap to enable/disable folding if it annoys me
local foldtoggle = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local msg = require('ufo.main').inspectBuf(bufnr)
    if not msg then
        require('ufo.main').attach(bufnr)
        print("UFO -- Folding enabled")
    else
        require("ufo").openAllFolds()
        require('ufo.main').detach(bufnr)
        print("UFO -- Folding disabled")
    end
end

vim.keymap.set("n", "zt", foldtoggle, { desc = "Toggle folding"})
