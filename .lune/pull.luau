--!nocheck
--!nolint
--# selene: allow(incorrect_standard_library_use)
local buildPlace = require("./utilities/remotePlace/buildPlace")
local config = require("config")
local processUtil = require("./utilities/other/processUtil")

print("[pull.luau]: Building from remote place..")
buildPlace(config.remotePlaceId)
processUtil.spawn("rojo", { "build", "build.project.json", "--output", config.localProjectFileDir })
print(string.format("[pull.luau]: ✅ Successfully built %s from remote place!", config.localProjectFileDir))
