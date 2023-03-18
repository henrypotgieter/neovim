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

local function getusername()
    local username = io.popen('whoami')
    if username then
        local usernamestr = username:read()
        return usernamestr
    end
    return "n/a"
end

vim.g.isroot = isroot()
vim.g.username = getusername()
