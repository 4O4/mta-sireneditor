local function addSirens(vehicle, sirenCount, sirenType, enable360, enableLOSCheck, enableRandomiser, enableSilent)
	local result = vehicle:addSirens(sirenCount, sirenType, enable360, enableLOSCheck, enableRandomiser, enableSilent)
	
	triggerClientEvent(source, Events.Client.AddSirensFinished, source, vehicle, result)
end

local function removeSirens(vehicle)
	local result = vehicle:removeSirens()
	
	triggerClientEvent(source, Events.Client.RemoveSirensFinished, source, vehicle, result)
end

local function setSirens(vehicle, sirenPoint, posX, posY, posZ, colorR, colorG, colorB, alpha, minAlpha)
	local result = true

	if type(sirenPoint) == "table" then
		local sirenPoints = sirenPoint

		for index, sirenPoint in ipairs(sirenPoints) do
			result = result and vehicle:setSirens(
				index,
				sirenPoint.posX,
				sirenPoint.posY,
				sirenPoint.posZ,
				sirenPoint.colorR,
				sirenPoint.colorG,
				sirenPoint.colorB,
				sirenPoint.alpha,
				sirenPoint.minAlpha
			)
		end
	else
		result = vehicle:setSirens(sirenPoint, posX, posY, posZ, colorR, colorG, colorB, alpha, minAlpha)
	end
	
	triggerClientEvent(source, Events.Client.SetSirensFinished, source, vehicle, result)
end

addEvent(Events.Server.AddSirens, true)
addEvent(Events.Server.RemoveSirens, true)
addEvent(Events.Server.SetSirens, true)

addEventHandler(Events.Server.AddSirens, root, addSirens)
addEventHandler(Events.Server.RemoveSirens, root, removeSirens)
addEventHandler(Events.Server.SetSirens, root, setSirens)