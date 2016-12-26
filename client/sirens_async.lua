function addVehicleSirensAsync(vehicle, sirenCount, sirenType, enable360, enableLOSCheck, enableRandomiser, enableSilent, done)
	if type(done) == "function" then

		function async(doneVehicle, ...)
			if source == localPlayer and doneVehicle == vehicle then
				removeEventHandler(Events.Client.AddSirensFinished, localPlayer, async)
				done(...)
			end
		end

		addEventHandler(Events.Client.AddSirensFinished, localPlayer, async)
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

		function async(doneVehicle, ...)
			if source == localPlayer and doneVehicle == vehicle then
				removeEventHandler(Events.Client.RemoveSirensFinished, localPlayer, async)
				done(...)
			end
		end

		addEventHandler(Events.Client.RemoveSirensFinished, localPlayer, async)
	end

	triggerServerEvent(
		Events.Server.RemoveSirens, 
		localPlayer,
		vehicle
	)
end

function setVehicleSirensAsync(vehicle, sirenPoint, posX, posY, posZ, colorR, colorG, colorB, alpha, minAlpha, done)
	if type(sirenPoint) == "table" then
		done = posX
	end
	
	if type(done) == "function" then

		function async(doneVehicle, ...)
			if source == localPlayer and doneVehicle == vehicle then
				removeEventHandler(Events.Client.SetSirensFinished, localPlayer, async)
				done(...)
			end
		end

		addEventHandler(Events.Client.SetSirensFinished, localPlayer, async)
	end

	triggerServerEvent(
		Events.Server.SetSirens, 
		localPlayer,
		vehicle,
		sirenPoint,
		posX,
		posY,
		posZ,
		colorR,
		colorG,
		colorB,
		alpha,
		minAlpha
	)
end

function Vehicle.addSirensAsync(...)
	return addVehicleSirensAsync(...)
end

function Vehicle.removeSirensAsync(...)
	return removeVehicleSirensAsync(...)
end

function Vehicle.setSirensAsync(...)
	return setVehicleSirensAsync(...)
end

addEvent(Events.Client.AddSirensFinished, true)
addEvent(Events.Client.RemoveSirensFinished, true)
addEvent(Events.Client.SetSirensFinished, true)