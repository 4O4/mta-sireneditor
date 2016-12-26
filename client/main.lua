local sirenPointsConfig = {} --table.copy(defaultSettings.sirens)
local syncInterval = 1000
local synchronizationNeeded = {}

function main()
	addCommandHandler("sireneditor", toggleMainWindow)
	setTimer(syncServerSirensWithLocal, syncInterval, 0)
end

function normalizeTableKeys(table, recursive)
	-- For consistent naming
	local map = {
		SirenCount 		= "sirenCount",
		sirenType 		= "sirenType",
		x 				= "posX",
		y 				= "posY",
		z 				= "posZ",
		Red 			= "colorR",
		Green 			= "colorG",
		Blue 			= "colorB",
		Alpha 			= "alpha",
		Min_Alpha 		= "minAlpha",
		["360"]			= "enable360",
		DoLOSCheck 		= "enableLOSCheck",
		UseRandomiser 	= "enableRandomiser",
		Silent 			= "enableSilent",
		Flags 			= "flags",
	}
	local newTable = {}
	local recursive = recursive or true

	for key, value in pairs(table) do
		if type(value) == "table" and recursive then
			newTable[map[key] or key] = normalizeTableKeys(value, recursive)
		else
			newTable[map[key] or key] = value
		end
	end

	return newTable
end

function getPlayersCount()
	return #Element.getAllByType("player")
end

function refreshSirenConfigTabsState()
	for i = 1, MAX_SIREN_COUNT do
		if i > localPlayer.vehicle:getSirenParams().SirenCount then
			gui.tabs.sirenConfig[i]:setEnabled(false)
			gui.labels.sirenColorMarker[i]:setVisible(false)
		else
			gui.tabs.sirenConfig[i]:setEnabled(true)
			gui.labels.sirenColorMarker[i]:setVisible(true)
		end
	end
end

function updateCurrentVehicleSirens(sirenPoints, sirenCount, sirenType, enable360, enableLOSCheck, enableRandomiser, enableSilent)
	if sirenCount == 0 then
		localPlayer.vehicle:removeSirensAsync(
			function (result)
				if not result then
					outputChatBox("Unexpected error: unable to remove sirens, check debug log", 255, 0, 0)
				end
				
				refreshSirenConfigTabsState()
			end
		)
	else
		localPlayer.vehicle:addSirensAsync(
			sirenCount,
			sirenType,
			enable360,
			enableLOSCheck,
			enableRandomiser,
			enableSilent,

			function (result)
				if result then
					for index, siren in pairs(sirenPoints) do
						localPlayer.vehicle:setSirens(
							index,
							siren.posX,
							siren.posY,
							siren.posZ,
							siren.colorR,
							siren.colorG,
							siren.colorB,
							siren.alpha,
							siren.minAlpha
						)
					end	
					
					localPlayer.vehicle:setSirensOn(true)
				else
					outputChatBox("Unexpected error: unable to add sirens, check debug log", 255, 0, 0)
				end

				refreshSirenConfigTabsState()
			end
		)
	end
end

function getSirenParamsFromGui()
	return { 
		gui.comboBoxes.sirenCount:getNumber(),
		gui.comboBoxes.sirenType:getNumber(), 
		gui.checkBoxes.enable360:getSelected(), 
		gui.checkBoxes.enableLOSCheck:getSelected(), 
		gui.checkBoxes.enableRandomiser:getSelected(), 
		gui.checkBoxes.enableSilent:getSelected() 
	}
end

function synchronizeGuiWithCurrentVehicleSirens()
	function synchronizeParams()
		local sirenParams = normalizeTableKeys(localPlayer.vehicle:getSirenParams())

		-- Combobox should have values 0-8, so items order will match 
		-- sirenCount perfectly. No further logic needed.
		gui.comboBoxes.sirenCount:setSelected(sirenParams.sirenCount)

		-- But correct sirenType index must be manually searched in table
		for index, sirenType in ipairs(SIREN_TYPES) do
			if SIREN_TYPES[index] == sirenParams.sirenType then
				gui.comboBoxes.sirenType:setSelected(index)
			end
		end

		for flagName, value in pairs(sirenParams.flags) do
			local checkbox = gui.checkBoxes[flagName]

			if isElement(checkbox) then
				checkbox:setSelected(value)
			else
				outputDebugString("Unknown sirenParams flag: " .. flagName, 2)
			end
		end

		if sirenParams.sirenCount == 0 then
			gui.tabPanels.main:setSelectedTab(gui.tabs.credits)
		end
	end

	function synchronizePoints()
		local sirens = normalizeTableKeys(localPlayer.vehicle:getSirens())

		for i = 1, MAX_SIREN_COUNT do
			if sirens[i] then
				sirenPointsConfig[i] = sirens[i]
			else
				sirenPointsConfig[i] = table.copy(defaultSettings.sirens[i] or defaultSettings.sirens[1])
			end

			gui.labels.sirenColorMarker[i]:setColor(
				sirenPointsConfig[i].colorR,
				sirenPointsConfig[i].colorG,
				sirenPointsConfig[i].colorB
			)

			sirenPointsConfig[i].posX = ("%.6f"):format(sirenPointsConfig[i].posX)
			sirenPointsConfig[i].posY = ("%.6f"):format(sirenPointsConfig[i].posY)
			sirenPointsConfig[i].posZ = ("%.6f"):format(sirenPointsConfig[i].posZ)
		end
		
		local selectedSirenConfigTab = getSelectedSirenConfigTab()

		if selectedSirenConfigTab then
			rebuildSirenPointControls(selectedSirenConfigTab, sirenPointsConfig[selectedSirenConfigTab:getNumber()])
		end
	end

	synchronizeParams()
	synchronizePoints()
end

function areVehicleSirensSynced(vehicle)
	return synchronizationNeeded[localPlayer.vehicle] ~= true
end

function syncServerSirensWithLocal()
	if isElement(localPlayer.vehicle) and not areVehicleSirensSynced(localPlayer.vehicle) then
		-- gui.labels.syncing:setVisible(true)

		localPlayer.vehicle:setSirensAsync(
			sirenPointsConfig,
			function (result) 
				if result  then
					-- outputDebugString("Synchronization finished succesfully")
					synchronizationNeeded[localPlayer.vehicle] = nil
					-- gui.labels.syncing:setVisible(false)
				else
					outputDebugString("There was some problem with syncing vehicle sirens, will retry in a moment", 2)
				end
			end
		)
	end
end

function handleGuiClicks()
	if source == gui.checkBoxes.enable360
		or source == gui.checkBoxes.enableLOSCheck
		or source == gui.checkBoxes.enableSilent
		or source == gui.checkBoxes.enableRandomiser
	then
		updateCurrentVehicleSirens(sirenPointsConfig, unpack(getSirenParamsFromGui()))
	end
end

function handleGuiComboBoxChange(source)
	if source == gui.comboBoxes.sirenCount
		or source == gui.comboBoxes.sirenType
	then
		local selectedSirenConfigTab = getSelectedSirenConfigTab()

		if selectedSirenConfigTab then
			if gui.comboBoxes.sirenCount:getNumber() == 0 then
				gui.tabPanels.main:setSelectedTab(gui.tabs.credits)
			elseif selectedSirenConfigTab:getNumber() > gui.comboBoxes.sirenCount:getNumber() then
				gui.tabPanels.main:setSelectedTab(gui.tabs.sirenConfig[gui.comboBoxes.sirenCount:getNumber()])
			end
		end

		updateCurrentVehicleSirens(sirenPointsConfig, unpack(getSirenParamsFromGui()))
	end
end

function getSelectedSirenConfigTab()
	for _, sirenConfigTab in ipairs(gui.tabs.sirenConfig) do
		if sirenConfigTab == gui.tabPanels.main:getSelectedTab() then
			return sirenConfigTab
		end
	end

	return nil
end

function handleTabChange(tab)
	local selectedSirenConfigTab = getSelectedSirenConfigTab()

	if selectedSirenConfigTab == tab then
		rebuildSirenPointControls(tab, sirenPointsConfig[tab:getNumber()])
	else
		-- It is one of additional tabs (About, Lua, XML...)
		destroyExistingSirenPointControls()
	end
end

function calculateColorValue(element)
	return math.round(element:getScrollPosition() / 100 * MAX_COLOR_VALUE)
end

function updateCurrentSirenPointColor()
	local selectedSirenConfigTab = getSelectedSirenConfigTab()

	if selectedSirenConfigTab then
		local currentSirenPoint = selectedSirenConfigTab:getNumber()
		local currentPointConfig = sirenPointsConfig[currentSirenPoint]

		if source == gui.scrollBars.currentSirenColorRed then
			currentPointConfig.colorR = calculateColorValue(gui.scrollBars.currentSirenColorRed)
		elseif source == gui.scrollBars.currentSirenColorGreen then
			currentPointConfig.colorG = calculateColorValue(gui.scrollBars.currentSirenColorGreen)
		elseif source == gui.scrollBars.currentSirenColorBlue then
			currentPointConfig.colorB = calculateColorValue(gui.scrollBars.currentSirenColorBlue)
		elseif source == gui.scrollBars.currentSirenColorAlpha then
			currentPointConfig.alpha = calculateColorValue(gui.scrollBars.currentSirenColorAlpha)
		elseif source == gui.scrollBars.currentSirenColorMinAlpha then
			currentPointConfig.minAlpha = calculateColorValue(gui.scrollBars.currentSirenColorMinAlpha)
		end

		gui.labels.currentSirenColorAll:setText(("R: %s\nG: %s\nB: %s"):format(currentPointConfig.colorR, currentPointConfig.colorG, currentPointConfig.colorB))
		gui.labels.currentSirenAlpha:setText(("Alpha: %s\nMin.: %s"):format(currentPointConfig.alpha, currentPointConfig.minAlpha))

		gui.labels.sirenColorMarker[currentSirenPoint]:setColor(
			currentPointConfig.colorR,
			currentPointConfig.colorG,
			currentPointConfig.colorB
		)

		localPlayer.vehicle:setSirens(
			currentSirenPoint,
			currentPointConfig.posX,
			currentPointConfig.posY,
			currentPointConfig.posZ,
			currentPointConfig.colorR,
			currentPointConfig.colorG,
			currentPointConfig.colorB,
			currentPointConfig.alpha,
			currentPointConfig.minAlpha
		)

		synchronizationNeeded[localPlayer.vehicle] = true
	end
end

function handleScrolling()
	if source == gui.scrollBars.currentSirenColorRed
		or source == gui.scrollBars.currentSirenColorGreen
		or source == gui.scrollBars.currentSirenColorBlue
		or source == gui.scrollBars.currentSirenColorAlpha
		or source == gui.scrollBars.currentSirenColorMinAlpha
	then
		updateCurrentSirenPointColor()
	end
end

function updateCurrentSirenPointPosition()
	local selectedSirenConfigTab = getSelectedSirenConfigTab()

	if selectedSirenConfigTab then
		local currentSirenPoint = selectedSirenConfigTab:getNumber()
		local currentPointConfig = sirenPointsConfig[currentSirenPoint]

		currentPointConfig.posX = gui.editBoxes.currentSirenPosX:getNumber()
		currentPointConfig.posY = gui.editBoxes.currentSirenPosY:getNumber()
		currentPointConfig.posZ = gui.editBoxes.currentSirenPosZ:getNumber()

		localPlayer.vehicle:setSirens(
			currentSirenPoint,
			currentPointConfig.posX,
			currentPointConfig.posY,
			currentPointConfig.posZ,
			currentPointConfig.colorR,
			currentPointConfig.colorG,
			currentPointConfig.colorB,
			currentPointConfig.alpha,
			currentPointConfig.minAlpha
		)

		synchronizationNeeded[localPlayer.vehicle] = true
	end
end

function inputCoordsAreValid()
	return gui.editBoxes.currentSirenPosX:getNumber() ~= nil
		and gui.editBoxes.currentSirenPosY:getNumber() ~= nil
		and gui.editBoxes.currentSirenPosZ:getNumber() ~= nil
end

function handleEditAccepted()
	if source == gui.editBoxes.currentSirenPosX
		or source == gui.editBoxes.currentSirenPosY
		or source == gui.editBoxes.currentSirenPosZ
	then
		if inputCoordsAreValid() then
			updateCurrentSirenPointPosition()
			gui.labels.positionHelp:setVisible(false)
			source:setProperty('NormalTextColour', 'FF007700')
		end
	end
end

function highlightInvalidNumber(element)
	if isElement(element) then
		if element:getNumber() == nil then
			element:setProperty('NormalTextColour', 'FFAA0000')
		else
			element:setProperty('NormalTextColour', 'FF000000')
		end
	end
end

function handleEditChanged()
	if source == gui.editBoxes.currentSirenPosX
		or source == gui.editBoxes.currentSirenPosY
		or source == gui.editBoxes.currentSirenPosZ
	then
		gui.labels.positionHelp:setVisible(true)
		highlightInvalidNumber(source)
	end
end

function initializeGui()
	buildGui()
	initializeGuiHandlers()
end

function initializeGuiHandlers()
	addEventHandler("onClientGUIClick", gui.windows.main, handleGuiClicks, true)
	addEventHandler("onClientGUIComboBoxAccepted", gui.windows.main, handleGuiComboBoxChange)
	addEventHandler("onClientGUITabSwitched", gui.tabPanels.main, handleTabChange)
	addEventHandler("onClientGUIScroll", gui.tabPanels.main, handleScrolling)
	addEventHandler("onClientGUIAccepted", gui.tabPanels.main, handleEditAccepted)
	addEventHandler("onClientGUIChanged", gui.tabPanels.main, handleEditChanged)
end

function toggleMainWindow()
	if not isElement(gui.windows.main) then
		initializeGui()
	end

	if gui.windows.main.visible then
		gui.windows.main:setVisible(false)
		showCursor(false)
	else
		if not localPlayer:isInVehicle() then
			return outputChatBox("You are not sitting in a vehicle", 255, 0, 0)
		end
	
		refreshSirenConfigTabsState()
		synchronizeGuiWithCurrentVehicleSirens()

		gui.windows.main:setVisible(true)
		showCursor(true)

		GuiElement.setInputMode("no_binds_when_editing")

		localPlayer.vehicle:setSirensOn(true)
	end
end

main()