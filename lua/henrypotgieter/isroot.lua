local function isroot()
	local id = io.popen('id | tr -d "()"')
	if id then
		local idstr = id:read()
		local idfilt = string.find(idstr, "^uid=0root ")
		if idfilt == 1 then
			return true
		end
	end
	return false
end

vim.g.isroot = isroot()
