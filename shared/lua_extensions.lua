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