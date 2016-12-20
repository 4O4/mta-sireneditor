-- local currentSirenPoint = 1

local sirensConfig = {}

sirensConfig[1] = table.copy(defaultSettings.sirens[1])

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

function updateCurrentVehicleSirens()
	local sirenCount = gui.comboBoxes.sirenCount:getNumber()

	if sirenCount == 0 then
		localPlayer.vehicle:removeSirensAsync(
			function ()
				refreshSirenConfigTabsState()
			end
		)
	else
		localPlayer.vehicle:addSirensAsync(
			sirenCount, 
			gui.comboBoxes.sirenType:getNumber(), 
			gui.checkBoxes.enable360:getSelected(), 
			gui.checkBoxes.enableLOSCheck:getSelected(), 
			gui.checkBoxes.enableRandomiser:getSelected(), 
			gui.checkBoxes.enableSilent:getSelected(),
			function ()
				for index, t in pairs(sirensConfig) do
					setVehicleSirens(localPlayer.vehicle, index, t.posX, t.posY, t.posZ, t.colorR, t.colorG, t.colorB, t.alpha, t.minAlpha)
				end	
				refreshSirenConfigTabsState()
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
		updateCurrentVehicleSirens()
	end
end

function handleGuiComboBoxChange(source)
	if source == gui.comboBoxes.sirenCount
		or source == gui.comboBoxes.sirenType
	then
		updateCurrentVehicleSirens()
	end
end

function handleTabChange(tab)
	for _, sirenConfigTab in ipairs(gui.tabs.sirenConfig) do
		if tab == sirenConfigTab then
			return rebuildSirenPointControls(tab)
		end
	end

	destroyExistingSirenPointControls()
end

function initializeGui()
	buildGui()
	buildSirenPointControls(gui.tabs.sirenConfig[1])

	addEventHandler("onClientGUIClick", gui.windows.main, handleGuiClicks, true)
	addEventHandler("onClientGUIComboBoxAccepted", gui.windows.main, handleGuiComboBoxChange)
	addEventHandler("onClientGUITabSwitched", gui.tabPanels.main, handleTabChange)	
end

function toggleMainWindow()
	if not isElement(gui.windows.main) then
		initializeGui()
	end

	refreshSirenConfigTabsState()

	if gui.windows.main.visible then
		gui.windows.main:setVisible(false)
		showCursor(false)
	else
		if not localPlayer:isInVehicle() then
			return outputChatBox("You must sit in a vehicle!", 255, 0, 0)
		end

		gui.windows.main:setVisible(true)
		showCursor(true)

		GuiElement.setInputMode("no_binds_when_editing")
	end
end

addCommandHandler("sireneditor", toggleMainWindow)


-- function math.round(number, decimals, method)
--     decimals = decimals or 0
--     local factor = 10 ^ decimals
--     if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
--     else return tonumber(("%." .. decimals .. "f"):format(number)) end
-- end

