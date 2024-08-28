--# selene: allow(incorrect_standard_library_use)
local process = require("@lune/process") :: any
local roblox = require("@lune/roblox") :: any

local authUtil = {}

function authUtil.cookie()
	local cookie = roblox.getAuthCookie()
	if cookie then
		return cookie
	end

	local cookieFromEnv = process.env.REMODEL_AUTH
	if cookieFromEnv and #cookieFromEnv > 0 then
		return `.ROBLOSECURITY={cookieFromEnv}`
	end

	for index, arg in process.args do
		if arg == "--auth" then
			local cookieFromArgs = process.args[index + 1]
			if cookieFromArgs and #cookieFromArgs > 0 then
				return `.ROBLOSECURITY={cookieFromArgs}`
			end
			break
		end
	end

	error([[
		Failed to find ROBLOSECURITY cookie for authentication!
		Make sure you have logged into studio, or set the ROBLOSECURITY environment variable.
	]])
end

return table.freeze(authUtil)
