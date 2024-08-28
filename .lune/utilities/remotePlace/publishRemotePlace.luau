--!nocheck
--!nolint
--# selene: allow(incorrect_standard_library_use)
local assetUtil = require("../other/assetUtil")
local config = require("../../config")
local enums = require("../../enums")
local fs = require("@lune/fs")
local buildLuneScriptInfo = require("../other/buildLuneScriptInfo")
local readRemotePlace = require("readRemotePlace")
local roblox = require("@lune/roblox")
local tableUtil = require("../other/tableUtil")
local task = require("@lune/task")
local writeToRemotePlace = require("../other/writeToRemotePlace")

local SHOULD_SETUP_BUILD_INFO_SCRIPT = true
local BLACKLISTED_SERVICES_CHILDREN = {
	Workspace = { "Camera" },
}

local function scriptIsKnown(service, script)
	if not config.scriptAssets[service.Name] then
		return false
	end

	if
		tableUtil.size(config.scriptAssets[service.Name]) == 1
		and typeof(config.scriptAssets[service.Name][1]) == "string"
	then
		return script.Name == config.scriptAssets[service.Name][1]
	end

	for key, folderData in config.scriptAssets[service.Name] do
		local dir = service

		if typeof(folderData) == "table" then
			dir = dir[key]

			if #folderData == 1 then
				if script.Name == folderData[1] then
					return true
				else
					continue
				end
			end
		end

		if script:IsDescendantOf(dir) then
			return true
		end
	end

	return false
end

local function publishRemotePlace(publishType)
	print(
		string.format(
			"[publishRemotePlace.luau]: Publishing local place %s to place id [%d]",
			config.localProjectFileDir,
			config.remotePlaceId
		)
	)
	-- roblox.readPlaceFile(config.localProjectFileDir)
	local localPlace = roblox.deserializePlace(fs.readFile(config.localProjectFileDir))

	if not localPlace then
		error(
			"[publishRemotePlace.luau]: Local place %s was not found!",
			config.localProjectFileDir
		)
	end

	print(
		string.format("[publishRemotePlace.luau]: Reading remote place %d..", config.remotePlaceId)
	)

	local updatedRemotePlace = readRemotePlace(config.remotePlaceId)

	for service in config.scriptAssets do
		local localService = localPlace:GetService(service)

		for _, child in localService:GetDescendants() do
			if child:IsA("Script") and not scriptIsKnown(localService, child) then
				warn(
					string.format(
						"[publishRemotePlace.luau]: Found unknown script [%s], will not sync it.",
						child:GetFullName()
					)
				)

				child:Destroy()
			end
		end
	end

	if publishType == enums.PublishType.EntireLocalPlace then
		for _, service in config.services do
			local localService = localPlace:GetService(service)

			for _, child in localService:GetChildren() do
				if
					BLACKLISTED_SERVICES_CHILDREN[service]
					and tableUtil.find(BLACKLISTED_SERVICES_CHILDREN[service], child.Name)
				then
					child:Destroy()
				end
			end

			for _, child in localService:GetDescendants() do
				if child:IsA("Script") and not scriptIsKnown(localService, child) then
					warn(
						string.format(
							"[publishRemotePlace.luau]: Found unknown script [%s], will not sync it.",
							child:GetFullName()
						)
					)
					child:Destroy()
				end
			end

			updatedRemotePlace:GetService(service):Destroy()
			localService.Parent = updatedRemotePlace
		end
	else
		assetUtil.destroyBlacklistedAssets(updatedRemotePlace, config.scriptAssets)
		assetUtil.copyAssetsToPlace(localPlace, updatedRemotePlace, config.scriptAssets)
	end

	if SHOULD_SETUP_BUILD_INFO_SCRIPT then
		buildLuneScriptInfo(updatedRemotePlace)
	end

	writeToRemotePlace(
		updatedRemotePlace,
		config.remotePlaceId,
		config.remoteUniverseId,
		config.cloudApiPublishingKey
	)
end

return publishRemotePlace
