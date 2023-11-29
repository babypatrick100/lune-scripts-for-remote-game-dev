--# selene: allow(incorrect_standard_library_use)
local luneBuildInfoScriptUtil = require("./util/other/luneBuildInfoScriptUtil") :: any

local config = {
	localProjectFileDir = "",
	localProjectAssetsDir = "project",
	remoteUniverseId = 0,
	remotePlaceId = 0,
	cloudApiPublishingKey = "",

	scriptAssets = {
		-- Where our scripts are stored - this is used internally to detect "unknown"
		-- scripts and not sync them in.
		ServerScriptService = { "earlyStartup", luneBuildInfoScriptUtil.buildInfoScriptName },
		ServerStorage = { "server", "serverPackages" },
		ReplicatedStorage = { "shared", "client", "sharedPackages" },
		StarterPlayer = { StarterPlayerScripts = { "lateStartup" } },
		ReplicatedFirst = { "client", luneBuildInfoScriptUtil.buildInfoScriptName },
	},

	services = {
		"ServerStorage",
		"ReplicatedFirst",
		"ReplicatedStorage",
		"ServerScriptService",
		"Workspace",
		"StarterPack",
		"StarterPlayer",
		"Lighting",
		"TextChatService",
		"Teams",
		"StarterGui",
		"SoundService",
		"Players",
		"MaterialService",
		"Chat",
	},
}

return table.freeze(config)
