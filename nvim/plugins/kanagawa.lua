local default_colors = require("kanagawa.colors").setup()

local overrides = {
	CocFloating = { fg = default_colors.fugiWhite, bg = default_colors.waveBlue1 },
	CocMenuSel = { fg = default_colors.fugiWhite, bg = default_colors.waveBlue2, bold = true },
}

require("kanagawa").setup({ overrides = overrides })
