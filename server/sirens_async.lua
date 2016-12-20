local function addSirens(vehicle, sirenCount, sirenType, enable360, enableLOSCheck, enableRandomiser, enableSilent)
	addVehicleSirens(vehicle, sirenCount, sirenType, enable360, enableLOSCheck, enableRandomiser, enableSilent)
	setVehicleSirensOn(vehicle, false)
	setVehicleSirensOn(vehicle, true)

	triggerClientEvent(source, Events.Client.AddedSirens, source, vehicle)
end

local function removeSirens(vehicle)
	removeVehicleSirens(vehicle)
	triggerClientEvent(source, Events.Client.RemovedSirens, source, vehicle)
end

addEvent(Events.Server.AddSirens, true)
addEvent(Events.Server.RemoveSirens, true)

addEventHandler(Events.Server.AddSirens, root, addSirens)
addEventHandler(Events.Server.RemoveSirens, root, removeSirens)