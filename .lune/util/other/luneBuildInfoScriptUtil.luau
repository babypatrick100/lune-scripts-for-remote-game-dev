--# selene: allow(incorrect_standard_library_use)

local roblox = require("@lune/roblox") :: any
local process = require("@lune/process") :: any
local numberUtil = require("numberUtil") :: any

local BUILD_INFO_SCRIPT_SERVICE_PARENT_INFO =
	{ ReplicatedFirst = "LocalScript", ServerScriptService = "Script" }

local luneBuildInfoScriptUtil = {
	buildInfoScriptName = "__LuneBuildInfo",
}

function luneBuildInfoScriptUtil.setup(updatedRemotePlace)
	for serviceName, scriptType in BUILD_INFO_SCRIPT_SERVICE_PARENT_INFO do
		local buildInfoScript = roblox.Instance.new(scriptType)
		buildInfoScript.Name = luneBuildInfoScriptUtil.buildInfoScriptName
		local formattedOsDate = os.date("!*t", os.time())
		buildInfoScript.Source = string.format(
			'warn(string.format("[lune]: Build %s %s %d [%d:%s %s] (from OS: %s)")) script:Destroy()',
			numberUtil.ordinalNumbers(formattedOsDate.day),
			os.date("%B"),
			formattedOsDate.year,
			numberUtil.h24toh12(formattedOsDate.hour),
			numberUtil.formatM(formattedOsDate.min),
			if formattedOsDate.hour >= 12 then "PM" else "AM",
			process.os
		)

		local parentService = updatedRemotePlace:GetService(serviceName)

		if parentService:FindFirstChild(luneBuildInfoScriptUtil.buildInfoScriptName) then
			parentService[luneBuildInfoScriptUtil.buildInfoScriptName]:Destroy()
		end

		buildInfoScript.Parent = parentService
	end
end

return table.freeze(luneBuildInfoScriptUtil)
