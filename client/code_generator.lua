local function interpolate(str, variables)
	function replace (w) 
		local new = variables[w:sub(3, -2)]

 		return (new ~= nil) and tostring(new) or w 
 	end
 	return str:gsub('($%b{})', replace)
end

getmetatable("").__mod = interpolate

local function generateCode(template, sirenParams, sirenPoints, vehicle)
	local params = CodeTemplates[template].SirenParams % sirenParams
	local points = {}
	local vehicle = isElement(vehicle) and vehicle or {}

	for index, point in ipairs(sirenPoints) do
		point.sirenPoint = index
		table.insert(points, CodeTemplates[template].SirenPoint % point)
	end

	return CodeTemplates[template].Full % {
		vehicleName = vehicle.name or "Unknown vehicle",
		vehicleModel = vehicle.model or "Unknown model",
		sirenParams = params,
		sirenPoints = table.concat(points, "\n")
	}
end

function generateLuaCode(sirenParams, sirenPoints, vehicle, OOP)
	return generateCode(OOP and "LuaOOP" or "Lua", sirenParams, sirenPoints, vehicle)
end

function generateXMLCode(sirenParams, sirenPoints, vehicle)
	return generateCode("XML", sirenParams, sirenPoints, vehicle)
end