local BUILD_INFO_SCRIPT_NAME = "buildInfo"

local config = {
	buildInfoScriptInfo = {
		name = BUILD_INFO_SCRIPT_NAME,
		parents = {
			ServerScriptService = "Script",
			ReplicatedFirst = "LocalScript",
		},
	},

	-- To be setup by the user:
	localProjectFileDir = nil,
	localProjectAssetsDir = nil,
	remoteUniverseId = nil,
	remotePlaceId = nil,
	cloudApiPublishingKey = nil,

	scriptAssets = {
		-- Where our scripts are stored - this is used internally to detect "unknown"
		-- scripts and not sync them in.
		ServerScriptService = { "earlyStartup", BUILD_INFO_SCRIPT_NAME },
		ServerStorage = { "server", "serverPackages" },
		ReplicatedStorage = { "shared", "client", "sharedPackages" },
		StarterPlayer = { StarterPlayerScripts = { "lateStartup", "packetprofiler" } },
		ReplicatedFirst = { "client", BUILD_INFO_SCRIPT_NAME },
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
