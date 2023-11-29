--!nocheck
--!nolint
--# selene: allow(incorrect_standard_library_use)
local processUtil = require("./util/other/processUtil")
local wallyInstall = require("./util/main/wallyInstall")

local PACKAGES_DIRS = { "Packages", "ServerPackages" }

print("[update.luau]: This will install all wally packages and update rojo related info.")

print("[update.luau]: Updating project..")

wallyInstall()
processUtil.spawn("rojo", { "sourcemap", "--output", "sourcemap.json" })

for _, dir in PACKAGES_DIRS do
	processUtil.spawn(
		"wally-package-types",
		{ "--sourcemap", "sourcemap.json", string.format("%s/", dir) }
	)
end

print("[update.luau]: Project successfully updated")
