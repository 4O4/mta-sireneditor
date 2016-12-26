defaultSettings = {
	global = {
		sirenCount       = 1,
		sirenType        = 2,
		enable360        = true,
		enableLOSCheck   = true,
		enableRandomiser = false,
		enableSilent     = false,
	},

	-- Explicit indexing for better navigation in this long table
	-- Default config for at least first siren must be provided!
	sirens = { 
		[1] = {
			posX = -0.5,
			posY = 2,
			posZ = 2,
			colorR = 255,
			colorG = 0,
			colorB = 0,
			alpha = 255,
			minAlpha = 190,
		},
		[2] = {
			posX = 0.5,
			posY = 2,
			posZ = 2,
			colorR = 255,
			colorG = 255,
			colorB = 0,
			alpha = 255,
			minAlpha = 190,
		},
		[3] = {
			posX = -0.5,
			posY = 1,
			posZ = 2,
			colorR = 255,
			colorG = 255,
			colorB = 255,
			alpha = 255,
			minAlpha = 190,
		},
		[4] = {
			posX = 0.5,
			posY = 1,
			posZ = 2,
			colorR = 0,
			colorG = 255,
			colorB = 0,
			alpha = 255,
			minAlpha = 190,
		},
		[5] = {
			posX = -0.5,
			posY = 0,
			posZ = 2,
			colorR = 0,
			colorG = 255,
			colorB = 255,
			alpha = 255,
			minAlpha = 190,
		},
		[6] = {
			posX = 0.5,
			posY = 0,
			posZ = 2,
			colorR = 0,
			colorG = 0,
			colorB = 255,
			alpha = 255,
			minAlpha = 190,
		},
		[7] = {
			posX = -0.5,
			posY = -1,
			posZ = 2,
			colorR = 255,
			colorG = 0,
			colorB = 255,
			alpha = 255,
			minAlpha = 190,
		},
		[8] = {
			posX = 0.5,
			posY = -1,
			posZ = 2,
			colorR = 255,
			colorG = 128,
			colorB = 128,
			alpha = 255,
			minAlpha = 190,
		}
	}
}