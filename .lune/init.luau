--!nocheck
--!nolint
local wallyInstall = require("./util/main/wallyInstall")
local processUtil = require("./util/other/processUtil")

local PACKAGES_DIRS = { "Packages", "ServerPackages" }

print("Initializing project..")

wallyInstall()
processUtil.spawn("lune", { "--setup" })
processUtil.spawn("rojo", { "sourcemap", "--output", "sourcemap.json" })

for _, dir in PACKAGES_DIRS do
	processUtil.spawn(
		"wally-package-types",
		{ "--sourcemap", "sourcemap.json", string.format("%s/", dir) }
	)
end

print("Project successfully initialized.")
