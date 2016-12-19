local gui = {
	windows    = {},
	tabPanels  = {},
	tabs       = {},
	buttons    = {},
	checkBoxes = {},
	labels     = {},
	editBoxes  = {},
	scrollbars = {},
	memos      = {}
}

local setting = {}
local sirenSettings = {}
setting["sirenCount"] = 1
setting["sirenType"] = 2
setting["360flag"] = false
setting["checklosflag"] = true
setting["randomizer"] = true
setting["silent"] = false
setting["usingsiren"] = 1

sirenSettings[1] = {}

sirenSettings[1]["x"] = 0
sirenSettings[1]["y"] = 0
sirenSettings[1]["z"] = 0
sirenSettings[1]["r"] = 0
sirenSettings[1]["g"] = 0
sirenSettings[1]["b"] = 0
sirenSettings[1]["a"] = 200
sirenSettings[1]["am"] = 200

local function preCreate()
	outputDebugString("PreCreate sireneditor-guielements")
	local screenWidth, screenHeight = guiGetScreenSize()
 
    local Width,Height = 475,290
    local X = (screenWidth/2) - (Width/2)
    local Y = (screenHeight/2) - (Height/2)
	
	gui.windows.main = guiCreateWindow(X, 0, Width, Height,"Siren Editor by Noneatme",false)
	gui.windows.output = guiCreateWindow(1200/1920*screenWidth,114/1080*screenHeight,307,176,"Output",false)
	gui.memos.output = guiCreateMemo(9,23,291,145,"",false,gui.windows.output)
	guiMemoSetReadOnly(gui.memos.output, true)
	guiSetVisible(gui.windows.output, false)
	
	
	gui.labels.globalSettings = guiCreateLabel(14,22,109,16,"Global Settings:",false,gui.windows.main)
	guiSetFont(gui.labels.globalSettings,"default-bold-small")
	gui.labels.underline = guiCreateLabel(11,26,135,15,"___________________",false,gui.windows.main)
	guiLabelSetColor(gui.labels.underline,0, 255, 0)
	guiSetFont(gui.labels.underline,"default-bold-small")
	gui.labels.sirenCount = guiCreateLabel(12,49,138,15,"Number of Sirens:(1-10)",false,gui.windows.main)
	guiSetFont(gui.labels.sirenCount,"default-bold-small")
	gui.editBoxes.sirenCount = guiCreateEdit(156,45,35,24,setting["sirenCount"],false,gui.windows.main)
	gui.labels.sirenType = guiCreateLabel(11,79,138,15,"Siren type: (1-?)",false,gui.windows.main)
	guiSetFont(gui.labels.sirenType,"default-bold-small")
	gui.editBoxes.sirenType = guiCreateEdit(156,75,35,24,setting["sirenType"],false,gui.windows.main)
	gui.labels.separator = guiCreateLabel(10,99,458,16,"______________________________________________________________________________",false,gui.windows.main)
	gui.checkBoxes.enable360 = guiCreateCheckBox(226,49,99,20,"360 Flag",false,false,gui.windows.main)
	guiSetFont(gui.checkBoxes.enable360,"default-bold-small")
	gui.checkBoxes.enableLOSCheck = guiCreateCheckBox(226,73,99,20,"checkLosFlag",false,false,gui.windows.main)
	guiSetFont(gui.checkBoxes.enableLOSCheck,"default-bold-small")
	gui.checkBoxes.enableRandomiser = guiCreateCheckBox(327,50,99,20,"Randomizer",false,false,gui.windows.main)
	guiSetFont(gui.checkBoxes.enableRandomiser,"default-bold-small")
	gui.checkBoxes.enableSilent = guiCreateCheckBox(327,74,99,20,"SilentFlag",false,false,gui.windows.main)
	guiSetFont(gui.checkBoxes.enableSilent,"default-bold-small")
	
	-- CHECKBOX --
	guiCheckBoxSetSelected(gui.checkBoxes.enable360,setting["360flag"])
	guiCheckBoxSetSelected(gui.checkBoxes.enableLOSCheck,setting["checklosflag"])
	guiCheckBoxSetSelected(gui.checkBoxes.enableRandomiser,setting["randomizer"])
	guiCheckBoxSetSelected(gui.checkBoxes.enableSilent,setting["silent"])
	
	gui.tabPanels.main = guiCreateTabPanel(9,148,456,129,false,gui.windows.main)
	gui.tabs.sirenPosition = guiCreateTab("Position",gui.tabPanels.main)	
	gui.tabs.sirenColor = guiCreateTab("Color",gui.tabPanels.main)
	
	gui.editBoxes.currentSirenPosX = guiCreateEdit(24,17,216,24,"0",false,gui.tabs.sirenPosition)
	gui.editBoxes.currentSirenPosY = guiCreateEdit(24,40,216,24,"0",false,gui.tabs.sirenPosition)
	gui.checkBoxes.currentSirenPosZ = guiCreateEdit(23,64,216,24,"0",false,gui.tabs.sirenPosition)
	gui.labels.currentSirenPosAll = guiCreateLabel(243,18,141,67,"X, Y, Z\n0, 0, 0",false,gui.tabs.sirenPosition)
	guiLabelSetVerticalAlign(gui.labels.currentSirenPosAll,"center")
	guiLabelSetHorizontalAlign(gui.labels.currentSirenPosAll,"center",false)
	guiSetFont(gui.labels.currentSirenPosAll,"default-bold-small")
	
	

	
	gui.scrollbars.currentSirenColorRed = guiCreateScrollBar(11,7,168,23,true,false,gui.tabs.sirenColor)
	gui.scrollbars.currentSirenColorGreen = guiCreateScrollBar(11,37,168,23,true,false,gui.tabs.sirenColor)
	gui.scrollbars.currentSirenColorBlue = guiCreateScrollBar(11,70,168,23,true,false,gui.tabs.sirenColor)
	
	gui.labels.currentSirenColorAll = guiCreateLabel(186,12,100,77,"R, G, B\n0, 0, 0",false,gui.tabs.sirenColor)
	guiLabelSetVerticalAlign(gui.labels.currentSirenColorAll,"center")
	guiLabelSetHorizontalAlign(gui.labels.currentSirenColorAll,"center",false)
	guiSetFont(gui.labels.currentSirenColorAll,"default-bold-small")
	
	
	gui.scrollbars.currentSirenColorAlpha = guiCreateScrollBar(310,2,22,102,false,false,gui.tabs.sirenColor)
	gui.scrollbars.currentSirenColorMinAlpha = guiCreateScrollBar(334,3,22,102,false,false,gui.tabs.sirenColor)
	
	gui.labels.currentSirenAlpha = guiCreateLabel(362,33,85,36,"Alpha: 0\nMinimum: 0",false,gui.tabs.sirenColor)
	guiLabelSetHorizontalAlign(gui.labels.currentSirenAlpha,"center",false)
	guiSetFont(gui.labels.currentSirenAlpha,"default-bold-small")
	gui.tabs.credits = guiCreateTab("Credits",gui.tabPanels.main)
	gui.labels.creditsInfo = guiCreateLabel(6,4,447,95,"This GUI-Siren Editor was made by Noneatme.\nDieser Sirenen-Editor wurde von Noneatme erstellt.\n\nThanks to the MTA developer for the awesome siren-functions!\n\nIf you have any question, you can PM me via www.forum.mta-sa.de",false,gui.tabs.credits)
	guiSetFont(gui.labels.creditsInfo,"default-bold-small")
	gui.labels.currentSirenPoint = guiCreateLabel(11,118,102,12,"Using siren Point: ",false,gui.windows.main)
	guiSetFont(gui.labels.currentSirenPoint,"default-bold-small")
	gui.buttons.previousSirenPoint = guiCreateButton(118,117,65,22,"<--",false,gui.windows.main)
	gui.labels.currentSirenPoint = guiCreateLabel(191,120,34,21,setting["usingsiren"],false,gui.windows.main)
	guiSetFont(gui.labels.currentSirenPoint,"default-bold-small")
	gui.buttons.nextSirenPoint = guiCreateButton(212,116,65,22,"-->",false,gui.windows.main)
	gui.buttons.apply = guiCreateButton(285,116,87,23,"Apply",false,gui.windows.main)
	gui.buttons.toggleOutputWindow = guiCreateButton(376,116,87,23,"View code",false,gui.windows.main)

	-- FUNCTIONS --
	local function applySettingsToRightSirenPoint(s)
		if not(sirenSettings[s]) then
			sirenSettings[s] = {}
			sirenSettings[s]["x"] = 0
			sirenSettings[s]["y"] = 0
			sirenSettings[s]["z"] = 0
			sirenSettings[s]["r"] = 0
			sirenSettings[s]["g"] = 0
			sirenSettings[s]["b"] = 0
			sirenSettings[s]["a"] = 200
			sirenSettings[s]["am"] = 200
		end
		guiSetText(gui.labels.currentSirenPosAll, "X, Y, Z\n"..sirenSettings[s]["x"]..", "..sirenSettings[s]["y"]..", "..sirenSettings[s]["z"])
		guiSetText(gui.labels.currentSirenColorAll, "R, G, B\n"..sirenSettings[s]["r"]..", "..sirenSettings[s]["g"]..", "..sirenSettings[s]["b"])
		guiSetText(gui.labels.currentSirenAlpha, "Alpha: "..sirenSettings[s]["a"].."\nMinimum: "..sirenSettings[s]["am"])
		guiLabelSetColor(gui.labels.currentSirenColorAll, sirenSettings[s]["r"], sirenSettings[s]["g"], sirenSettings[s]["b"], sirenSettings[s]["a"])
		
	--	guiSetText(gui.editBoxes.currentSirenPosX, sirenSettings[s]["x"]);
	--	guiSetText(gui.editBoxes.currentSirenPosY, sirenSettings[s]["y"]);
	--	guiSetText(gui.checkBoxes.currentSirenPosZ, sirenSettings[s]["z"]);
		
		--[[	
		guiScrollBarSetScrollPosition(gui.editBoxes.currentSirenPosX, (sirenSettings[s]["x"]+5)*200/20)
		guiScrollBarSetScrollPosition(gui.editBoxes.currentSirenPosY, (sirenSettings[s]["y"]+5)*200/20)
		guiScrollBarSetScrollPosition(gui.checkBoxes.currentSirenPosZ, (sirenSettings[s]["z"]+5)*200/20)
		
		guiScrollBarSetScrollPosition(gui.scrollbars.currentSirenColorRed, sirenSettings[s]["r"]/2.55)
		guiScrollBarSetScrollPosition(gui.scrollbars.currentSirenColorGreen, sirenSettings[s]["g"]/2.55)
		guiScrollBarSetScrollPosition(gui.scrollbars.currentSirenColorBlue, sirenSettings[s]["b"]/2.55)
		guiScrollBarSetScrollPosition(gui.scrollbars.currentSirenColorAlpha, sirenSettings[s]["a"]/2.55)
		guiScrollBarSetScrollPosition(gui.scrollbars.currentSirenColorMinAlpha, sirenSettings[s]["am"]/2.55)]]
		
		triggerServerEvent("onSireneditorSirenApply", localPlayer, setting["sirenCount"], setting["sirenType"], setting["360flag"], setting["checklosflag"], setting["randomizer"], setting["silent"], sirenSettings)
	
	end
	-- EVENT HANDLERS --
	-- ROLL EVENT ODER WIE MAN DAS NENNT :D --
	-- POSITION --
	addEventHandler("onClientGUIChanged", gui.editBoxes.currentSirenPosX, function()
		local pos = tonumber(guiGetText(source))
		sirenSettings[setting["usingsiren"]]["x"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	addEventHandler("onClientGUIChanged", gui.editBoxes.currentSirenPosY, function()
		local pos = tonumber(guiGetText(source))
		sirenSettings[setting["usingsiren"]]["y"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	addEventHandler("onClientGUIChanged", gui.checkBoxes.currentSirenPosZ, function()
		local pos = tonumber(guiGetText(source))
		sirenSettings[setting["usingsiren"]]["z"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	-- COLOR 
	addEventHandler("onClientGUIScroll", gui.scrollbars.currentSirenColorRed, function()
		local pos = math.round( guiScrollBarGetScrollPosition(source)*2.55, 1, "round" )
		sirenSettings[setting["usingsiren"]]["r"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	addEventHandler("onClientGUIScroll", gui.scrollbars.currentSirenColorGreen, function()
		local pos = math.round( guiScrollBarGetScrollPosition(source)*2.55, 1, "round" )
		sirenSettings[setting["usingsiren"]]["g"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	addEventHandler("onClientGUIScroll", gui.scrollbars.currentSirenColorBlue, function()
		local pos = math.round( guiScrollBarGetScrollPosition(source)*2.55, 1, "round" )
		sirenSettings[setting["usingsiren"]]["b"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	addEventHandler("onClientGUIScroll", gui.scrollbars.currentSirenColorAlpha, function()
		local pos = math.round( guiScrollBarGetScrollPosition(source)*2.55, 1, "round" )
		sirenSettings[setting["usingsiren"]]["a"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	addEventHandler("onClientGUIScroll", gui.scrollbars.currentSirenColorMinAlpha, function()
		local pos = math.round( guiScrollBarGetScrollPosition(source)*2.55, 1, "round" )
		sirenSettings[setting["usingsiren"]]["am"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	-- CHANGE EVENT --
	addEventHandler("onClientGUIChanged", gui.editBoxes.sirenCount, function()
		local anzahl = tonumber(guiGetText(source))
		if not(anzahl) or (anzahl < 1) or (anzahl > 8) then 
			outputChatBox("Falsche Eingabe! Es duerfen maximal 8 Sirenen sein, und minimal 1.", 255, 0, 0)
			return
		end
		setting["sirenCount"] = anzahl
		for i = 1, anzahl, 1 do
			if not(sirenSettings[i]) then
				sirenSettings[i] = {}
				sirenSettings[i]["x"] = 0
				sirenSettings[i]["y"] = 0
				sirenSettings[i]["z"] = 0
				sirenSettings[i]["r"] = 0
				sirenSettings[i]["g"] = 0
				sirenSettings[i]["b"] = 0
				sirenSettings[i]["a"] = 200
				sirenSettings[i]["am"] = 200
			end
		end
	end)
	
	addEventHandler("onClientGUIChanged", gui.editBoxes.sirenType, function()
		local anzahl = tonumber(guiGetText(source))
		if not(anzahl) or (anzahl < 1) or (anzahl > 6) then 
			outputChatBox("Falsche Eingabe! Minimal 1 und Maximal 6.", 255, 0, 0)
			return
		end
		setting["sirenentyp"] = anzahl
	end)
	-- CLICK EVENTS --
	-- APPLY --
	addEventHandler("onClientGUIClick", gui.buttons.apply, function()
		triggerServerEvent("onSireneditorSirenApply", localPlayer, setting["sirenCount"], setting["sirenType"], setting["360flag"], setting["checklosflag"], setting["randomizer"], setting["silent"], sirenSettings)
	end, false)
	-- VIEW CODE --
	addEventHandler("onClientGUIClick", gui.buttons.toggleOutputWindow, function()
		if(guiGetVisible(gui.windows.output) == true) then
			guiSetVisible(gui.windows.output, false)
			guiSetText(source, "View code")
		else
			guiSetVisible(gui.windows.output, true)
			guiSetText(source, "Hide code")
			local text = ""
			text = text.."removeVehicleSirens(veh)\n"
			
			text = text.."addVehicleSirens(veh, "..setting["sirenCount"]..", "..setting["sirenType"]..", "..tostring(setting["360flag"])..", "..tostring(setting["checklosflag"])..", "..tostring(setting["randomizer"])..", "..tostring(setting["silent"])..")\n"
			
			for i = 1, setting["sirenCount"], 1 do
				if(sirenSettings[i]) then
					text = text.."setVehicleSirens(veh, "..i..", "..sirenSettings[i]["x"]..", "..sirenSettings[i]["y"]..", "..sirenSettings[i]["z"]..", "..sirenSettings[i]["r"]..", "..sirenSettings[i]["g"]..", "..sirenSettings[i]["b"]..", "..sirenSettings[i]["a"]..", "..sirenSettings[i]["am"]..")\n"
				end
			end
			guiSetText(gui.memos.output, text)
		end
	end, false)
	-- CHECKBOXES --
	addEventHandler("onClientGUIClick", gui.checkBoxes.enable360, function()
		setting["360flag"] = guiCheckBoxGetSelected(source)
	end, false)
	addEventHandler("onClientGUIClick", gui.checkBoxes.enableLOSCheck, function()
		setting["checklosflag"] = guiCheckBoxGetSelected(source)
	end, false)
	addEventHandler("onClientGUIClick", gui.checkBoxes.enableRandomiser, function()
		setting["randomizer"] = guiCheckBoxGetSelected(source)
	end, false)
	addEventHandler("onClientGUIClick", gui.checkBoxes.enableSilent, function()
		setting["silent"] = guiCheckBoxGetSelected(source)
	end, false)

	-- BACK 
	addEventHandler("onClientGUIClick", gui.buttons.previousSirenPoint, function()
		if(setting["usingsiren"] < 2) then return end
		setting["usingsiren"] = setting["usingsiren"]-1
		guiSetText(gui.labels.currentSirenPoint, setting["usingsiren"])
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end, false)
	addEventHandler("onClientGUIClick", gui.buttons.nextSirenPoint, function()
		if(setting["usingsiren"] > 10) then return end
		if(setting["usingsiren"] > setting["sirenCount"]-1) then return end
		setting["usingsiren"] = setting["usingsiren"]+1
		guiSetText(gui.labels.currentSirenPoint, setting["usingsiren"])
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end, false)
	
	guiSetVisible(gui.windows.main, false)
end
preCreate()

addCommandHandler("sireneditor", function()
	if(guiGetVisible(gui.windows.main) == true) then
		guiSetVisible(gui.windows.main, false)
		guiSetVisible(gui.windows.output, false)
		showCursor(false)
	else
		if(isPedInVehicle(localPlayer) == false) then
			outputChatBox("Du musst in einem Fahrzeug sein/You must sit in a vehicle!", 255, 0, 0)
			return
		end
		guiSetVisible(gui.windows.main, true)
		if(guiGetText(gui.buttons.toggleOutputWindow) == "Hide code") then
			guiSetVisible(gui.windows.output, true)
		end
		showCursor(true)
		guiSetInputMode("no_binds_when_editing")
	end
end)


function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end