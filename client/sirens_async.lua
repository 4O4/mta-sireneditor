function addVehicleSirensAsync(vehicle, sirenCount, sirenType, enable360, enableLOSCheck, enableRandomiser, enableSilent, done)
	if type(done) == "function" then

		function async(doneVehicle)
			if source == localPlayer and doneVehicle == vehicle then
				removeEventHandler(Events.Client.AddedSirens, localPlayer, async)
				done()
			end
		end

		addEventHandler(Events.Client.AddedSirens, localPlayer, async)
	end

	triggerServerEvent(
		Events.Server.AddSirens, 
		localPlayer,
		vehicle,
		sirenCount, 
		sirenType, 
		enable360, 
		enableLOSCheck, 
		enableRandomiser, 
		enableSilent
	)
end

function removeVehicleSirensAsync(vehicle, done)
	if type(done) == "function" then

		function async(doneVehicle)
			if source == localPlayer and doneVehicle == vehicle then
				removeEventHandler(Events.Client.RemovedSirens, localPlayer, async)
				done()
			end
		end

		addEventHandler(Events.Client.RemovedSirens, localPlayer, async)
	end

	triggerServerEvent(
		Events.Server.RemoveSirens, 
		localPlayer,
		vehicle
	)
end

function Vehicle.addSirensAsync(...)
	return addVehicleSirensAsync(...)
end

function Vehicle.removeSirensAsync(...)
	return removeVehicleSirensAsync(...)
end

addEvent(Events.Client.AddedSirens, true)
addEvent(Events.Client.RemovedSirens, true)