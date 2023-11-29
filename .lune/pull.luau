--!nocheck
--!nolint
--# selene: allow(incorrect_standard_library_use)
local buildPlace = require("./util/main/buildPlace")
local config = require("config")
local processUtil = require("./util/other/processUtil")

buildPlace(config.remotePlaceId)
print(
	string.format("[pull.luau]: Building %s from the project folder..", config.localProjectFileDir)
)
processUtil.spawn("rojo", { "build", "build.project.json", "--output", config.localProjectFileDir })
print(string.format("[pull.luau]: Built %s!", config.localProjectFileDir))
