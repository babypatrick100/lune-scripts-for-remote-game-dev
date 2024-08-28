--!nocheck
--!nolint
--# selene: allow(incorrect_standard_library_use)
local enums = require("enums")
local process = require("@lune/process")
local publishRemotePlace = require("./utilities/remotePlace/publishRemotePlace")
local stdio = require("@lune/stdio")

local PUBLISH_LOCAL_PLACE_SERVICES_ARG = "entire"

local args = process.args

if args[1] ~= nil and args[1]:lower() == PUBLISH_LOCAL_PLACE_SERVICES_ARG then
	local confirmed = stdio.prompt(
		"confirm",
		"This will sync in your entire local file to the actual game on Roblox, are you sure you want to do this?"
	)

	if not confirmed then
		return
	end

	publishRemotePlace(enums.PublishType.EntireLocalPlace)
else
	publishRemotePlace()
end
