--# selene: allow(incorrect_standard_library_use)
local BUILD_INFO_SCRIPT_NAME = "buildInfo"
local CUSTOM_CONFIG_FILE_DIR = "../dev/remoteGameDevConfig"

local CONFIG_TEMPLATE = {
	buildInfoScriptInfo = {
		name = BUILD_INFO_SCRIPT_NAME,
		parents = {
			ServerScriptService = "Script",
			ReplicatedFirst = "LocalScript",
		},
		shouldSetup = true,
	},

	localProjectFileDir = nil,
	localProjectAssetsDir = nil,
	remoteUniverseId = nil,
	remotePlaceId = nil,
	cloudApiPublishingKey = nil,

	scriptAssets = {
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

local wasSuccessful, projectSpecificConfig = pcall(function()
	return require(CUSTOM_CONFIG_FILE_DIR)
end)

if wasSuccessful then
	for key in CONFIG_TEMPLATE do
		if projectSpecificConfig[key] == nil then
			print(string.format('⚠️ Member "%s" was found in config file!', key))
		end
	end

	for key in projectSpecificConfig do
		if CONFIG_TEMPLATE[key] == nil then
			print(string.format('⚠️ Unknown member "%s" was found in config file!', key))
		end
	end

	return projectSpecificConfig
else
	error(string.format("Expected config file `remoteGameDevConfig.luau` in `dev` folder at root."))
end
