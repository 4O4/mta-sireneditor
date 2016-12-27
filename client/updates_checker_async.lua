function getLatestVersionNumberAsync(done)	
	if type(done) == "function" then

		function async(...)
			if source == localPlayer then
				removeEventHandler(Events.Client.GetLatestVersionNumberFinished, localPlayer, async)
				done(...)
			end
		end

		addEventHandler(Events.Client.GetLatestVersionNumberFinished, localPlayer, async)
	end

	triggerServerEvent(Events.Server.GetLatestVersionNumber, localPlayer, async)
end

addEvent(Events.Client.GetLatestVersionNumberFinished, true)