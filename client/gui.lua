gui = {
	windows    = {}, 
	tabPanels  = {}, 
	tabs       = {}, 
	buttons    = {}, 
	checkBoxes = {}, 
	labels     = {}, 
	editBoxes  = {}, 
	scrollBars = {}, 
	memos      = {},
	comboBoxes = {},
}

local screenWidth, screenHeight = GuiElement.getScreenSize()

local function buildOutputGui()
	gui.windows.output = GuiWindow(1200 / 1920 * screenWidth, 114 / 1080 * screenHeight, 307, 176, "Output", false)
	gui.windows.output:setVisible(false)

	gui.memos.output = GuiMemo(9, 23, 291, 145, "", false, gui.windows.output)
	gui.memos.output:setReadOnly(true)
end

function updateCreditsInfo(newVersion)
	gui.labels.creditsInfo:setText(("License: GPLv2 %99s\nAuthor: Pawelo %90s\n\nYou can report issues, create pull requests or check for updates on GitHub:\n     https://github.com/%s\n\nOriginal author (v1.0.0): Noneatme\n\n"):format("Current version: " .. VERSION, newVersion and ("Newer version is available! (%s) "):format(newVersion) or "", GITHUB_REPO))
end

local function buildMainGui()
	function buildGlobalSettingsGui()
		local mainWindowWidth, mainWindowHeight = 475, 252
	    local mainWindowPosX = (screenWidth / 2) - (mainWindowWidth / 2)
	    local mainWindowPosY = 0 -- (screenHeight / 2) - (mainWindowHeight / 2)

		gui.windows.main = GuiWindow(mainWindowPosX, mainWindowPosY, mainWindowWidth, mainWindowHeight, "Siren Editor " .. VERSION, false)
		gui.windows.main:setVisible(false)

		gui.labels.sirenCount = GuiLabel(12, 31, 100, 15, "Number of Sirens:", false, gui.windows.main)
		gui.labels.sirenCount:setFont("default-bold-small")
		gui.labels.sirenCount:setHorizontalAlign("right")

		gui.comboBoxes.sirenCount = GuiComboBox(120, 27, 45, 165, defaultSettings.global.sirenCount, false, gui.windows.main)
		
		for i = 0, MAX_SIREN_COUNT do
			gui.comboBoxes.sirenCount:addItem(i)
		end
		
		
		gui.labels.sirenType = GuiLabel(11, 61, 100, 15, "Siren type:", false, gui.windows.main)
		gui.labels.sirenType:setFont("default-bold-small")
		gui.labels.sirenType:setHorizontalAlign("right")
		
		gui.comboBoxes.sirenType = GuiComboBox(120, 57, 45, 110, defaultSettings.global.sirenType, false, gui.windows.main)

		for _, sirenType in ipairs(SIREN_TYPES) do
			gui.comboBoxes.sirenType:addItem(sirenType)
		end

		
		gui.checkBoxes.enable360 = GuiCheckBox(209, 31, 99, 20, "360 Effect", false, false, gui.windows.main)
		gui.checkBoxes.enable360:setFont("default-bold-small")
		gui.checkBoxes.enable360:setSelected(defaultSettings.global.enable360)
		
		gui.checkBoxes.enableSilent = GuiCheckBox(209, 56, 99, 20, "Silent", false, false, gui.windows.main)
		gui.checkBoxes.enableSilent:setFont("default-bold-small")
		gui.checkBoxes.enableSilent:setSelected(defaultSettings.global.enableSilent)
		
		gui.checkBoxes.enableRandomiser = GuiCheckBox(310, 31, 130, 20, "Enable randomiser", false, false, gui.windows.main)
		gui.checkBoxes.enableRandomiser:setFont("default-bold-small")
		gui.checkBoxes.enableRandomiser:setSelected(defaultSettings.global.enableRandomiser)
		
		gui.checkBoxes.enableLOSCheck = GuiCheckBox(310, 56, 130, 20, "Check line of sight", false, false, gui.windows.main)
		gui.checkBoxes.enableLOSCheck:setFont("default-bold-small")
		gui.checkBoxes.enableLOSCheck:setSelected(defaultSettings.global.enableLOSCheck)
		
		gui.labels.separator = GuiLabel(10, 81, 458, 16, ("_"):rep(78), false, gui.windows.main)

		-- gui.labels.syncing = GuiLabel(295, 96, 160, 16, "Syncing with other players...", false, gui.windows.main)
		-- gui.labels.syncing:setFont("default-bold-small")
		-- gui.labels.syncing:setVisible(false)

		gui.labels.positionHelp = GuiLabel(295, 96, 160, 16, "Press ENTER to set position", false, gui.windows.main)
		gui.labels.positionHelp:setFont("default-bold-small")
		gui.labels.positionHelp:setHorizontalAlign("right")
		gui.labels.positionHelp:setVisible(false)
	end

	function buildTabs()
		gui.tabPanels.main = GuiTabPanel(9, 110, 456, 129, false, gui.windows.main)

		gui.tabs.sirenConfig = {}
		gui.labels.sirenColorMarker = {}

		local currentColorMarkerPosX = 15
		for i = 1, MAX_SIREN_COUNT do
			gui.tabs.sirenConfig[i] = GuiTab(i .. "  ", gui.tabPanels.main)
			gui.labels.sirenColorMarker[i] = GuiLabel(currentColorMarkerPosX, 98, 20, 13, "▄▄▄", false, gui.windows.main)

			currentColorMarkerPosX = currentColorMarkerPosX + 35
		end

		gui.tabs.separatorTab = GuiTab("     ", gui.tabPanels.main)
		gui.tabs.separatorTab:setEnabled(false)

		-- gui.tabs.sirenPosition = GuiTab("Position", gui.tabPanels.main)	
		-- gui.tabs.sirenColor = GuiTab("Color", gui.tabPanels.main)

		gui.tabs.xmlOutput = GuiTab("XML", gui.tabPanels.main)
		gui.tabs.luaOutput = GuiTab("Lua", gui.tabPanels.main)
		gui.tabs.credits = GuiTab("About", gui.tabPanels.main)
		
		gui.labels.creditsInfo = GuiLabel(6, 4, 447, 100, "", false, gui.tabs.credits)
		gui.labels.creditsInfo:setFont("default-bold-small")
		updateCreditsInfo()

		-- gui.labels.currentSirenPoint = GuiLabel(11, 118, 110, 20, "Current siren point:", false, gui.windows.main)
		-- gui.labels.currentSirenPoint:setFont("default-bold-small")

		-- gui.buttons.previousSirenPoint = GuiButton(122, 115, 21, 22, "<", false, gui.windows.main)
		-- gui.buttons.nextSirenPoint = GuiButton(172, 115, 21, 22, ">", false, gui.windows.main)
		
		-- gui.labels.currentSirenPoint = GuiLabel(154, 118, 15, 21, currentSirenPoint, false, gui.windows.main)
		-- gui.labels.currentSirenPoint:setFont("default-bold-small")

		-- gui.buttons.apply = GuiButton(325, 82, 80, 23, "Apply", false, gui.windows.main)
		-- gui.buttons.apply:setProperty("NormalTextColour", "FFFF0000")
		-- gui.buttons.toggleOutputWindow = GuiButton(376, 116, 87, 23, "View code", false, gui.windows.main)
	end

	buildGlobalSettingsGui()
	buildTabs()
end

function destroyExistingSirenPointControls()
	for _, element in ipairs(
		{
			gui.labels.currentSirenPosX,
			gui.labels.currentSirenPosY,
			gui.labels.currentSirenPosZ,
			gui.editBoxes.currentSirenPosX,
			gui.editBoxes.currentSirenPosY,
			gui.editBoxes.currentSirenPosZ,
			gui.scrollBars.currentSirenColorRed,
			gui.scrollBars.currentSirenColorGreen,
			gui.scrollBars.currentSirenColorBlue,
			gui.labels.currentSirenColorAll,
			gui.scrollBars.currentSirenColorAlpha,
			gui.scrollBars.currentSirenColorMinAlpha,
			gui.labels.currentSirenAlpha,
		}
	) do
		if isElement(element) then
			element:destroy()
		end
	end
end

function buildSirenPointControls(parent, sirenPointConfig)
	gui.labels.currentSirenPosX = GuiLabel(7, 13, 10, 24, "X:", false, parent)
	gui.labels.currentSirenPosX:setFont("default-bold-small")
	gui.labels.currentSirenPosY = GuiLabel(7, 44, 10, 24, "Y:", false, parent)
	gui.labels.currentSirenPosY:setFont("default-bold-small")
	gui.labels.currentSirenPosZ = GuiLabel(7, 76, 10, 24, "Z:", false, parent)
	gui.labels.currentSirenPosZ:setFont("default-bold-small")
	
	gui.editBoxes.currentSirenPosX = GuiEdit(24, 9, 80, 24, sirenPointConfig.posX, false, parent)
	gui.editBoxes.currentSirenPosX:setMaxLength(9)
	gui.editBoxes.currentSirenPosY = GuiEdit(24, 40, 80, 24, sirenPointConfig.posY, false, parent)
	gui.editBoxes.currentSirenPosY:setMaxLength(9)
	gui.editBoxes.currentSirenPosZ = GuiEdit(24, 71, 80, 24, sirenPointConfig.posZ, false, parent)
	gui.editBoxes.currentSirenPosZ:setMaxLength(9)
	
	gui.scrollBars.currentSirenColorRed = GuiScrollBar(113, 7, 168, 23, true, false, parent)
	gui.scrollBars.currentSirenColorGreen = GuiScrollBar(113, 38, 168, 23, true, false, parent)
	gui.scrollBars.currentSirenColorBlue = GuiScrollBar(113, 70, 168, 23, true, false, parent)
	
	gui.labels.currentSirenColorAll = GuiLabel(290, 18, 141, 67, ("R: %s\nG: %s\nB: %s"):format(sirenPointConfig.colorR, sirenPointConfig.colorG, sirenPointConfig.colorB), false, parent)
	gui.labels.currentSirenColorAll:setVerticalAlign("center")
	gui.labels.currentSirenColorAll:setHorizontalAlign("left", false)
	gui.labels.currentSirenColorAll:setFont("default-bold-small")
	
	gui.scrollBars.currentSirenColorAlpha = GuiScrollBar(332, 1, 22, 102, false, false, parent)
	gui.scrollBars.currentSirenColorMinAlpha = GuiScrollBar(356, 1, 22, 102, false, false, parent)
	
	gui.labels.currentSirenAlpha = GuiLabel(372, 33, 85, 36, ("Alpha: %s\nMin.: %s"):format(sirenPointConfig.alpha, sirenPointConfig.minAlpha), false, parent)
	gui.labels.currentSirenAlpha:setHorizontalAlign("center", false)
	gui.labels.currentSirenAlpha:setFont("default-bold-small")

	-- Scroll setters must be called after labels are created
	gui.scrollBars.currentSirenColorRed:setScrollPosition(sirenPointConfig.colorR / MAX_COLOR_VALUE * 100)
	gui.scrollBars.currentSirenColorGreen:setScrollPosition(sirenPointConfig.colorG / MAX_COLOR_VALUE * 100)
	gui.scrollBars.currentSirenColorBlue:setScrollPosition(sirenPointConfig.colorB / MAX_COLOR_VALUE * 100)

	gui.scrollBars.currentSirenColorAlpha:setScrollPosition(sirenPointConfig.alpha / MAX_COLOR_VALUE * 100)
	gui.scrollBars.currentSirenColorMinAlpha:setScrollPosition(sirenPointConfig.minAlpha / MAX_COLOR_VALUE * 100)
end

function rebuildSirenPointControls(parent, sirenPointConfig)
	destroyExistingSirenPointControls()
	buildSirenPointControls(parent, sirenPointConfig)
end

function buildGui()
	-- buildOutputGui()
	buildMainGui()

	-- FUNCTIONS --
	local function applySettingsToRightSirenPoint(s)
		if not(sirensConfig[s]) then
			sirensConfig[s] = {}
			sirensConfig[s]["posX"] = 0
			sirensConfig[s]["posY"] = 0
			sirensConfig[s]["posZ"] = 0
			sirensConfig[s]["colorR"] = 0
			sirensConfig[s]["colorG"] = 0
			sirensConfig[s]["colorB"] = 0
			sirensConfig[s]["alpha"] = 200
			sirensConfig[s]["minAlpha"] = 200
		end
		gui.labels.currentSirenColorAll:setText("R: " .. sirensConfig[s]["colorR"] .. "\nG: " .. sirensConfig[s]["colorG"] .. "\nB: " .. sirensConfig[s]["colorB"])
		gui.labels.currentSirenAlpha:setText("Alpha: " .. sirensConfig[s]["alpha"] .. "\nMin.: " .. sirensConfig[s]["minAlpha"])
		gui.labels.currentSirenColorAll:setColor( sirensConfig[s]["colorR"], sirensConfig[s]["colorG"], sirensConfig[s]["colorB"], sirensConfig[s]["alpha"])

		gui.labels.sirenColorMarker[1]:setColor(sirensConfig[s]["colorR"], sirensConfig[s]["colorG"], sirensConfig[s]["colorB"])
		
		
		-- triggerServerEvent(Events.Server.AddSirens, localPlayer, gui.comboBoxes.sirenCount:getNumber(), gui.comboBoxes.sirenType:getNumber(), gui.checkBoxes.enable360:getSelected(), gui.checkBoxes.enableLOSCheck:getSelected(), gui.checkBoxes.enableRandomiser:getSelected(), gui.checkBoxes.enableSilent:getSelected(), {}) --sirensConfig)
	
	end
end