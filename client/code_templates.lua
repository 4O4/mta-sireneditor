CodeTemplates = {
	Lua = {
		SirenParams = "addVehicleSirens(vehicle, ${sirenCount}, ${sirenType}, ${enable360}, ${enableLOSCheck}, ${enableRandomiser}, ${enableSilent})",
		SirenPoint = "setVehicleSirens(vehicle, ${sirenPoint}, ${posX}, ${posY}, ${posZ}, ${colorR}, ${colorG}, ${colorB}, ${alpha}, ${minAlpha})",
		Full = 'local vehicle = Element.getAllByType("vehicle")[1]\n\n${sirenParams}\n\n${sirenPoints}'
	},
	XML = {
		SirenParams = '<sirens sirenCount="${sirenCount}" sirenType="${sirenType}" flag360="${enable360}" checkLos="${enableLOSCheck}" useRandomiser="${enableRandomiser}" silent="${enableSilent}">',
		SirenPoint = '\t<siren sirenPoint="${sirenPoint}" posX="${posX}" posY="${posY}" posZ="${posZ}" red="${colorR}" green="${colorG}" blue="${colorB}" alpha="${alpha}" minAlpha="${minAlpha}" />',
		Full = '${sirenParams}\n${sirenPoints}\n</sirens>'
	},
}