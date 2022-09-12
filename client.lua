local tableLang = {}
local tableAccessLan = {
	{"ru","Русский"},
	{"en","English"},
}

setLanguage = function(lang)
    local default = xmlLoadFile("lang/ru.lg")
    local xml = xmlLoadFile("lang/"..lang..".lg")
    if not xml then xml = default end
	local defaultlangNode = xmlNodeGetChildren(default)
	local langNode = xmlNodeGetChildren(xml)
	tableLang = {}

	for i,node in ipairs(defaultlangNode) do 
		local xmlNodeName = xmlNodeGetName(node)
		if not tableLang[xmlNodeName] then tableLang[xmlNodeName] = {} end

		local defaultstring = xmlNodeGetAttribute(node, "string")
		local string = langNode[i] and xmlNodeGetAttribute(langNode[i], "string") or defaultstring
		tableLang[xmlNodeName][defaultstring] = string
	end
	xmlUnloadFile(default)
	xmlUnloadFile(xml)

	local FileLang = nil
	if fileExists("language") then
		FileLang = fileOpen("language")
	else
		FileLang = fileCreate("language")
	end
	if (FileLang) then
		fileWrite(FileLang, lang)
		fileClose(FileLang)
	end

	setElementData(localPlayer,"language",lang)
	triggerEvent("changeLanguage",localPlayer,tableLang)
end;

getLanguage = function()
	triggerEvent("changeLanguage",localPlayer,tableLang)
end;
addEvent("getLanguage",true)
addEventHandler("getLanguage", root, getLanguage)

DGS = exports.DGS
tableElemenD = {}
stateOn = nil
function languageWindow(state, windC)
	if state == "off" and stateOn then
		for _, item in pairs(tableElemenD) do
			if isElement(item) then 
				destroyElement(item) 
			end
		end
		stateOn = nil
		return
	end
	if stateOn then return end
	stateOn = true
	local language = getElementData(localPlayer,"language")
	tableElemenD.bold = dxCreateFont(":panel_shared/Fonts/Roboto/Roboto-Bold.ttf", 12, false, "proof") or 'default';
	tableElemenD.comboBox = DGS:dgsCreateComboBox(0.85, 0.075, 0.1, 0.04, "Language", true, windC, 30, tocolor(255,255,255), 0.8, 0.8, nil, nil, nil, tocolor(100, 40, 120), tocolor(100, 40, 120), tocolor(100, 40, 120))
	DGS:dgsSetProperty(tableElemenD.comboBox,"font",tableElemenD.bold)
	DGS:dgsSetProperty(tableElemenD.comboBox,"itemColor",{tocolor(20, 20, 20),tocolor(120, 120, 120),tocolor(100, 40, 120)})
	

	for lanID, lanName in ipairs(tableAccessLan) do
		DGS:dgsComboBoxAddItem(tableElemenD.comboBox, lanName[2])
		if lanName[1] == (language or "en") then
			DGS:dgsComboBoxSetSelectedItem(tableElemenD.comboBox,lanID)
		end
	end

	addEventHandler("onDgsComboBoxSelect",tableElemenD.comboBox,function(current,previous)
		if tableAccessLan[current] then
			setLanguage(tableAccessLan[current][1])
		end
	end, false)
end
addEvent("languageWindow:open",true)
addEventHandler("languageWindow:open", root, languageWindow)

addEventHandler("onClientResourceStart", resourceRoot, function(startedRes)
	local FileLang = nil
	if fileExists("language") then
		FileLang = fileOpen("language")
		if (FileLang) then
			local count = fileGetSize(FileLang)
			local data = fileRead(FileLang, count)
			fileClose(FileLang)
			setLanguage(data)
		end
	else
		FileLang = fileCreate("language")
		if (FileLang) then
			fileWrite(FileLang, "ru")
			fileClose(FileLang)
			setLanguage("ru")
		end
	end
end)