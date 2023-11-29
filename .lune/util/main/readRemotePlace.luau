--!nolint
--!nocheck
--# selene: allow(incorrect_standard_library_use)
local authUtil = require("../other/authUtil")
local net = require("@lune/net")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")
local task = require("@lune/task")

local ROBLOX_PLACE_ASSSET_DELIEVERY_URL = "https://assetdelivery.roblox.com/v2/assetId/%d"

local function readRemotePlace(remotePlaceId)
	local cookie = authUtil.cookie()

	while true do
		-- 1. Send a request to the asset delivery API, which will respond with cdn
		-- download link(s)
		local assetApiResponse = net.request({
			url = string.format(ROBLOX_PLACE_ASSSET_DELIEVERY_URL, remotePlaceId),
			headers = {
				Accept = "application/json",
				Cookie = cookie,
			},
		})

		if not assetApiResponse.ok then
			error(
				string.format(
					"Failed to fetch asset download link for asset id %s!\n%s (%s)\n%s",
					tostring(remotePlaceId),
					tostring(assetApiResponse.statusCode),
					tostring(assetApiResponse.statusMessage),
					tostring(assetApiResponse.body)
				)
			)
		end

		-- 2. Make sure we got a valid response body
		local decodedResponse = serde.decode("json", assetApiResponse.body)

		if typeof(decodedResponse) ~= "table" then
			error(
				string.format(
					"Asset delivery API returned no download locations!\n%s",
					assetApiResponse.body
				)
			)
		elseif typeof(decodedResponse.locations) ~= "table" then
			error(
				string.format(
					"Asset delivery API returned an invalid response body!\n%s",
					assetApiResponse.body
				)
			)
		end

		-- 3. Grab the first asset download location - we only requested one in
		-- in our query, so this will be correct
		local firstLocation = serde.decode("json", assetApiResponse.body).locations[1]

		if typeof(firstLocation) ~= "table" then
			error(
				string.format(
					"Asset delivery API returned no download locations!\n%s",
					assetApiResponse.body
				)
			)
		elseif typeof(firstLocation.location) ~= "string" then
			error(
				string.format(
					"Asset delivery API returned no valid download locations!\n%s",
					assetApiResponse.body
				)
			)
		end

		-- 5. Fetch the place contents from the cdn
		local cdnResponse = net.request({
			url = firstLocation.location,
			headers = {
				Cookie = cookie,
			},
		})

		if not assetApiResponse.ok then
			error(
				string.format(
					"Failed to fetch asset download link for asset id %s!\n%s (%s)\n%s",
					remotePlaceId,
					tostring(assetApiResponse.statusCode),
					tostring(assetApiResponse.statusMessage),
					tostring(assetApiResponse.body)
				)
			)
		end

		-- 6. The response body should now be the contents of the asset file
		local deserializedPlace = roblox.deserializePlace(cdnResponse.body)
		return deserializedPlace
	end

	return nil, nil
end

return readRemotePlace
