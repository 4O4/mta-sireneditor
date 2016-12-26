-- Missing OOP defs, polyfill is needed until version in which my pull request
-- was merged (https://github.com/multitheftauto/mtasa-blue/pull/97)

if getVersion().sortable >= "1.5.3-9.10986.0" then return end

function Vehicle:getSirenParams()
	return getVehicleSirenParams(self)
end