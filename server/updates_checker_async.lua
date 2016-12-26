local function getLatestVersionNumber()
	fetchRemote(
		("https://api.github.com/repos/%s/releases/latest"):format(GITHUB_REPO),
		function (data, err, source)
			if err == 0 then
				local data = fromJSON(data)
				triggerClientEvent(source, Events.Client.GetLatestVersionNumberFinished, source, err, data.tag_name)
			else
				outputDebugString("Unable to check for updates! Error code: " .. err, 2)
				triggerClientEvent(source, Events.Client.GetLatestVersionNumberFinished, source, err)
			end
		end,
		"",
		false,
		source
	)
end

addEvent(Events.Server.GetLatestVersionNumber, true)
addEventHandler(Events.Server.GetLatestVersionNumber, root, getLatestVersionNumber)