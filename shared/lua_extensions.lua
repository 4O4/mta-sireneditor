function table.copy(theTable)
	local newTable = {}

	for key, value in pairs(theTable) do
		if type(value) == "table" then
			newTable[key] = table.copy(value)
		else
			newTable[key] = value
		end
	end
	
	return newTable
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%." .. decimals .. "f"):format(number)) end
end