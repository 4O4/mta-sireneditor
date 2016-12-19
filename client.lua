local VERSION = "1.1.0"
local screenWidth, screenHeight = GuiElement.getScreenSize()

local gui = {
	windows    = {}, 
	tabPanels  = {}, 
	tabs       = {}, 
	buttons    = {}, 
	checkBoxes = {}, 
	labels     = {}, 
	editBoxes  = {}, 
	scrollBars = {}, 
	memos      = {}
}

local currentSirenPoint = 1

local defaultSettings = {
	global = {
		sirenCount       = 1,
		sirenType        = 2,
		enable360        = true,
		enableLOSCheck   = true,
		enableRandomiser = false,
		enableSilent     = false,
	},
	siren =	{
		posX = 0,
		posY = 0,
		posZ = 2,
		colorR = 255,
		colorG = 255,
		colorB = 255,	
	}
}

local sirenSettings = {}

sirenSettings[1] = {}
sirenSettings[1]["posX"] = 0
sirenSettings[1]["posY"] = 0
sirenSettings[1]["posZ"] = 0
sirenSettings[1]["colorR"] = 0
sirenSettings[1]["colorG"] = 0
sirenSettings[1]["colorB"] = 0
sirenSettings[1]["alpha"] = 200
sirenSettings[1]["minAlpha"] = 200



function GuiElement:getNumber()
	return tonumber(self:getText())
end

local function buildOutputGui()
	gui.windows.output = GuiWindow(1200 / 1920 * screenWidth, 114 / 1080 * screenHeight, 307, 176, "Output", false)
	gui.windows.output:setVisible(false)

	gui.memos.output = GuiMemo(9, 23, 291, 145, "", false, gui.windows.output)
	gui.memos.output:setReadOnly(true)
end    

local function buildMainGui()
	function buildGlobalSettingsGui()
		local mainWindowWidth, mainWindowHeight = 475, 290
	    local mainWindowPosX = (screenWidth / 2) - (mainWindowWidth / 2)
	    local mainWindowPosY = 0 -- (screenHeight / 2) - (mainWindowHeight / 2)

		gui.windows.main = GuiWindow(mainWindowPosX, mainWindowPosY, mainWindowWidth, mainWindowHeight, "Siren Editor v" .. VERSION, false)
		gui.windows.main:setVisible(false)
			
		gui.labels.globalSettings = GuiLabel(14, 22, 109, 16, "Global Settings:", false, gui.windows.main)
		gui.labels.globalSettings:setFont("default-bold-small")

		gui.labels.underline = GuiLabel(11, 26, 135, 15, ("_"):rep(15), false, gui.windows.main)
		gui.labels.underline:setColor(0, 255, 0)
		gui.labels.underline:setFont("default-bold-small")

		gui.labels.sirenCount = GuiLabel(12, 49, 138, 15, "Number of Sirens: (1-8)", false, gui.windows.main)
		gui.labels.sirenCount:setFont("default-bold-small")

		gui.editBoxes.sirenCount = GuiEdit(156, 45, 35, 24, defaultSettings.global.sirenCount, false, gui.windows.main)
		
		gui.labels.sirenType = GuiLabel(11, 79, 138, 15, "Siren type: (1-6)", false, gui.windows.main)
		gui.labels.sirenType:setFont("default-bold-small")
		
		gui.editBoxes.sirenType = GuiEdit(156, 75, 35, 24, defaultSettings.global.sirenType, false, gui.windows.main)
		
		gui.checkBoxes.enable360 = GuiCheckBox(226, 49, 99, 20, "360 Flag", false, false, gui.windows.main)
		gui.checkBoxes.enable360:setFont("default-bold-small")
		gui.checkBoxes.enable360:setSelected(defaultSettings.global.enable360)
		
		gui.checkBoxes.enableLOSCheck = GuiCheckBox(226, 73, 99, 20, "checkLosFlag", false, false, gui.windows.main)
		gui.checkBoxes.enableLOSCheck:setFont("default-bold-small")
		gui.checkBoxes.enableLOSCheck:setSelected(defaultSettings.global.enableLOSCheck)
		
		gui.checkBoxes.enableRandomiser = GuiCheckBox(327, 50, 99, 20, "Randomiser", false, false, gui.windows.main)
		gui.checkBoxes.enableRandomiser:setFont("default-bold-small")
		gui.checkBoxes.enableRandomiser:setSelected(defaultSettings.global.enableRandomiser)
		
		gui.checkBoxes.enableSilent = GuiCheckBox(327, 74, 99, 20, "SilentFlag", false, false, gui.windows.main)
		gui.checkBoxes.enableSilent:setFont("default-bold-small")
		gui.checkBoxes.enableSilent:setSelected(defaultSettings.global.enableSilent)
		
		gui.labels.separator = GuiLabel(10, 99, 458, 16, ("_"):rep(78), false, gui.windows.main)
	end

	function buildSirenPointsSettingsGui()
		gui.tabPanels.main = GuiTabPanel(9, 148, 456, 129, false, gui.windows.main)
		
		gui.tabs.sirenPosition = GuiTab("Position", gui.tabPanels.main)	
		gui.tabs.sirenColor = GuiTab("Color", gui.tabPanels.main)
		
		gui.editBoxes.currentSirenPosX = GuiEdit(24, 17, 216, 24, "0", false, gui.tabs.sirenPosition)
		gui.editBoxes.currentSirenPosY = GuiEdit(24, 40, 216, 24, "0", false, gui.tabs.sirenPosition)
		gui.editBoxes.currentSirenPosZ = GuiEdit(23, 64, 216, 24, "0", false, gui.tabs.sirenPosition)

		gui.labels.currentSirenPosAll = GuiLabel(243, 18, 141, 67, "X, Y, Z\n0, 0, 0", false, gui.tabs.sirenPosition)
		gui.labels.currentSirenPosAll:setVerticalAlign("center")
		gui.labels.currentSirenPosAll:setHorizontalAlign("center", false)
		gui.labels.currentSirenPosAll:setFont("default-bold-small")
		
		gui.scrollBars.currentSirenColorRed = GuiScrollBar(11, 7, 168, 23, true, false, gui.tabs.sirenColor)
		gui.scrollBars.currentSirenColorGreen = GuiScrollBar(11, 37, 168, 23, true, false, gui.tabs.sirenColor)
		gui.scrollBars.currentSirenColorBlue = GuiScrollBar(11, 70, 168, 23, true, false, gui.tabs.sirenColor)
		
		gui.labels.currentSirenColorAll = GuiLabel(186, 12, 100, 77, "R, G, B\n0, 0, 0", false, gui.tabs.sirenColor)
		gui.labels.currentSirenColorAll:setVerticalAlign("center")
		gui.labels.currentSirenColorAll:setHorizontalAlign("center", false)
		gui.labels.currentSirenColorAll:setFont("default-bold-small")
		
		gui.scrollBars.currentSirenColorAlpha = GuiScrollBar(310, 2, 22, 102, false, false, gui.tabs.sirenColor)
		gui.scrollBars.currentSirenColorMinAlpha = GuiScrollBar(334, 3, 22, 102, false, false, gui.tabs.sirenColor)
		
		gui.labels.currentSirenAlpha = GuiLabel(362, 33, 85, 36, "Alpha: 0\nMinimum: 0", false, gui.tabs.sirenColor)
		gui.labels.currentSirenAlpha:setHorizontalAlign("center", false)
		gui.labels.currentSirenAlpha:setFont("default-bold-small")

		gui.tabs.credits = GuiTab("Credits", gui.tabPanels.main)
		
		gui.labels.creditsInfo = GuiLabel(6, 4, 447, 95, "", false, gui.tabs.credits)
		gui.labels.creditsInfo:setFont("default-bold-small")
		gui.labels.creditsInfo:setText("Original author: Noneatme" .. string.rep(" ", 70) .. "License: GPLv2\nUpdated and maintained by: Pawelo\n\nYou can report issues or create pull requests on GitHub:\n\nhttps://github.com/4O4/mta-sireneditor\n\n")

		gui.labels.currentSirenPoint = GuiLabel(11, 118, 102, 12, "Using siren Point: ", false, gui.windows.main)
		gui.labels.currentSirenPoint:setFont("default-bold-small")

		gui.buttons.previousSirenPoint = GuiButton(118, 117, 65, 22, "<--", false, gui.windows.main)
		gui.buttons.nextSirenPoint = GuiButton(212, 116, 65, 22, "-->", false, gui.windows.main)
		
		gui.labels.currentSirenPoint = GuiLabel(191, 120, 34, 21, currentSirenPoint, false, gui.windows.main)
		gui.labels.currentSirenPoint:setFont("default-bold-small")

		gui.buttons.apply = GuiButton(285, 116, 87, 23, "Apply", false, gui.windows.main)
		gui.buttons.toggleOutputWindow = GuiButton(376, 116, 87, 23, "View code", false, gui.windows.main)
	end

	buildGlobalSettingsGui()
	buildSirenPointsSettingsGui()
end

local function buildGui()
	outputDebugString("PreCreate sireneditor-guielements")

	buildOutputGui()
	buildMainGui()

	-- FUNCTIONS --
	local function applySettingsToRightSirenPoint(s)
		if not(sirenSettings[s]) then
			sirenSettings[s] = {}
			sirenSettings[s]["posX"] = 0
			sirenSettings[s]["posY"] = 0
			sirenSettings[s]["posZ"] = 0
			sirenSettings[s]["colorR"] = 0
			sirenSettings[s]["colorG"] = 0
			sirenSettings[s]["colorB"] = 0
			sirenSettings[s]["alpha"] = 200
			sirenSettings[s]["minAlpha"] = 200
		end
		gui.labels.currentSirenPosAll:setText("X, Y, Z\n" .. sirenSettings[s]["posX"] .. ", " .. sirenSettings[s]["posY"] .. ", " .. sirenSettings[s]["posZ"])
		gui.labels.currentSirenColorAll:setText("R, G, B\n" .. sirenSettings[s]["colorR"] .. ", " .. sirenSettings[s]["colorG"] .. ", " .. sirenSettings[s]["colorB"])
		gui.labels.currentSirenAlpha:setText("Alpha: " .. sirenSettings[s]["alpha"] .. "\nMinimum: " .. sirenSettings[s]["minAlpha"])
		gui.labels.currentSirenColorAll:setColor( sirenSettings[s]["colorR"], sirenSettings[s]["colorG"], sirenSettings[s]["colorB"], sirenSettings[s]["alpha"])
		
		
		triggerServerEvent("onSireneditorSirenApply", localPlayer, gui.editBoxes.sirenCount:getNumber(), gui.editBoxes.sirenType:getNumber(), gui.checkBoxes.enable360:getSelected(), gui.checkBoxes.enableLOSCheck:getSelected(), gui.checkBoxes.enableRandomiser:getSelected(), gui.checkBoxes.enableSilent:getSelected(), sirenSettings)
	
	end

	-- POSITION --
	addEventHandler("onClientGUIChanged", gui.editBoxes.currentSirenPosX, function()
		local pos = tonumber(source:getText())
		sirenSettings[currentSirenPoint]["posX"] = pos
		applySettingsToRightSirenPoint(currentSirenPoint)
	end)
	addEventHandler("onClientGUIChanged", gui.editBoxes.currentSirenPosY, function()
		local pos = tonumber(source:getText())
		sirenSettings[currentSirenPoint]["posY"] = pos
		applySettingsToRightSirenPoint(currentSirenPoint)
	end)
	addEventHandler("onClientGUIChanged", gui.editBoxes.currentSirenPosZ, function()
		local pos = tonumber(source:getText())
		sirenSettings[currentSirenPoint]["posZ"] = pos
		applySettingsToRightSirenPoint(currentSirenPoint)
	end)

	-- COLOR 
	addEventHandler("onClientGUIScroll", gui.scrollBars.currentSirenColorRed, function()
		local pos = math.round( source:getScrollPosition() * 2.55, 1, "round" )
		sirenSettings[currentSirenPoint]["colorR"] = pos
		applySettingsToRightSirenPoint(currentSirenPoint)
	end)
	addEventHandler("onClientGUIScroll", gui.scrollBars.currentSirenColorGreen, function()
		local pos = math.round( source:getScrollPosition() * 2.55, 1, "round" )
		sirenSettings[currentSirenPoint]["colorG"] = pos
		applySettingsToRightSirenPoint(currentSirenPoint)
	end)
	addEventHandler("onClientGUIScroll", gui.scrollBars.currentSirenColorBlue, function()
		local pos = math.round( source:getScrollPosition() * 2.55, 1, "round" )
		sirenSettings[currentSirenPoint]["colorB"] = pos
		applySettingsToRightSirenPoint(currentSirenPoint)
	end)
	addEventHandler("onClientGUIScroll", gui.scrollBars.currentSirenColorAlpha, function()
		local pos = math.round( source:getScrollPosition() * 2.55, 1, "round" )
		sirenSettings[currentSirenPoint]["alpha"] = pos
		applySettingsToRightSirenPoint(currentSirenPoint)
	end)
	addEventHandler("onClientGUIScroll", gui.scrollBars.currentSirenColorMinAlpha, function()
		local pos = math.round( source:getScrollPosition() * 2.55, 1, "round" )
		sirenSettings[currentSirenPoint]["minAlpha"] = pos
		applySettingsToRightSirenPoint(currentSirenPoint)
	end)

	-- CHANGE EVENT --
	addEventHandler("onClientGUIChanged", gui.editBoxes.sirenCount, function()
		local anzahl = tonumber(source:getText())
		if not(anzahl) or (anzahl < 1) or (anzahl > 8) then 
			outputChatBox("Falsche Eingabe! Es duerfen maximal 8 Sirenen sein, und minimal 1.", 255, 0, 0)
			return
		end
		-- gui.editBoxes.sirenCount:getNumber() = anzahl
		for i = 1, anzahl, 1 do
			if not(sirenSettings[i]) then
				sirenSettings[i] = {}
				sirenSettings[i]["posX"] = 0
				sirenSettings[i]["posY"] = 0
				sirenSettings[i]["posZ"] = 0
				sirenSettings[i]["colorR"] = 0
				sirenSettings[i]["colorG"] = 0
				sirenSettings[i]["colorB"] = 0
				sirenSettings[i]["alpha"] = 200
				sirenSettings[i]["minAlpha"] = 200
			end
		end
	end)
	
	addEventHandler("onClientGUIChanged", gui.editBoxes.sirenType, function()
		local anzahl = tonumber(source:getText())
		if not(anzahl) or (anzahl < 1) or (anzahl > 6) then 
			outputChatBox("Falsche Eingabe! Minimal 1 und Maximal 6.", 255, 0, 0)
			return
		end
		-- setting["sirenentyp"] = anzahl
	end)

	-- CLICK EVENTS --
	-- APPLY --
	addEventHandler("onClientGUIClick", gui.buttons.apply, function()
		triggerServerEvent("onSireneditorSirenApply", localPlayer, gui.editBoxes.sirenCount:getNumber(), gui.editBoxes.sirenType:getNumber(), gui.checkBoxes.enable360:getSelected(), gui.checkBoxes.enableLOSCheck:getSelected(), gui.checkBoxes.enableRandomiser:getSelected(), gui.checkBoxes.enableSilent:getSelected(), sirenSettings)
	end, false)

	-- VIEW CODE --
	addEventHandler("onClientGUIClick", gui.buttons.toggleOutputWindow, function()
		if(gui.windows.output:getVisible() == true) then
			gui.windows.output:setVisible(false)
			source:setText("View code")
		else
			gui.windows.output:setVisible(true)
			source:setText("Hide code")
			local text = ""
			text = text .. "removeVehicleSirens(veh)\n"
			
			text = text .. "addVehicleSirens(veh, " .. gui.editBoxes.sirenCount:getNumber() .. ", " .. gui.editBoxes.sirenType:getNumber() .. ", " .. tostring(gui.checkBoxes.enable360:getSelected()) .. ", " .. tostring(gui.checkBoxes.enableLOSCheck:getSelected()) .. ", " .. tostring(gui.checkBoxes.enableRandomiser:getSelected()) .. ", " .. tostring(gui.checkBoxes.enableSilent:getSelected()) .. ")\n"
			
			for i = 1, gui.editBoxes.sirenCount:getNumber(), 1 do
				if(sirenSettings[i]) then
					text = text .. "setVehicleSirens(veh, " .. i .. ", " .. sirenSettings[i]["posX"] .. ", " .. sirenSettings[i]["posY"] .. ", " .. sirenSettings[i]["posZ"] .. ", " .. sirenSettings[i]["colorR"] .. ", " .. sirenSettings[i]["colorG"] .. ", " .. sirenSettings[i]["colorB"] .. ", " .. sirenSettings[i]["alpha"] .. ", " .. sirenSettings[i]["minAlpha"] .. ")\n"
				end
			end
			gui.memos.output:setText(text)
		end
	end, false)

	-- BACK 
	addEventHandler("onClientGUIClick", gui.buttons.previousSirenPoint, function()
		if(currentSirenPoint < 2) then return end
		currentSirenPoint = currentSirenPoint-1
		gui.labels.currentSirenPoint:setText(currentSirenPoint)
		applySettingsToRightSirenPoint(currentSirenPoint)
	end, false)
	addEventHandler("onClientGUIClick", gui.buttons.nextSirenPoint, function()
		if(currentSirenPoint > 10) then return end
		if(currentSirenPoint > gui.editBoxes.sirenCount:getNumber()-1) then return end
		currentSirenPoint = currentSirenPoint+1
		gui.labels.currentSirenPoint:setText(currentSirenPoint)
		applySettingsToRightSirenPoint(currentSirenPoint)
	end, false)
	
end
buildGui()

addCommandHandler("sireneditor", function()
	if(gui.windows.main:getVisible() == true) then
		gui.windows.main:setVisible(false)
		gui.windows.output:setVisible(false)
		showCursor(false)
	else
		if not localPlayer:isInVehicle() then
			outputChatBox("Du musst in einem Fahrzeug sein / You must sit in a vehicle!", 255, 0, 0)
			return
		end
		gui.windows.main:setVisible(true)
		if(gui.buttons.toggleOutputWindow:getText() == "Hide code") then
			gui.windows.output:setVisible(true)
		end
		showCursor(true)
		GuiElement.setInputMode("no_binds_when_editing")
	end
end)


function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%." .. decimals .. "f"):format(number)) end
end