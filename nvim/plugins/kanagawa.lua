require('kanagawa').setup({
  overrides = function(colors)
    return {
      CocFloating = { fg = colors.palette.fugiWhite, bg = colors.palette.waveBlue1 },
      CocMenuSel = { fg = colors.palette.fugiWhite, bg = colors.palette.waveBlue2, bold = true },
    }
  end,
})
