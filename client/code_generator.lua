local function interpolate(str, variables)
	function replace (w) 
 		return tostring(variables[w:sub(3, -2)]) or w 
 	end
 	return str:gsub('($%b{})', replace)
end

getmetatable("").__mod = interpolate

local function generateCode(template, sirenParams, sirenPoints)
	local params = CodeTemplates[template].SirenParams % sirenParams
	local points = {}

	for index, point in ipairs(sirenPoints) do
		point.sirenPoint = index
		table.insert(points, CodeTemplates[template].SirenPoint % point)
	end

	return CodeTemplates[template].Full % {
		sirenParams = params,
		sirenPoints = table.concat(points, "\n")
	}
end

function generateLuaCode(sirenParams, sirenPoints)
	return generateCode("Lua", sirenParams, sirenPoints)
end

function generateXMLCode(sirenParams, sirenPoints)
	return generateCode("XML", sirenParams, sirenPoints)
end