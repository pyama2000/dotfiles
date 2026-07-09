return {
  "rebelot/kanagawa.nvim",
  config = function()
    require("kanagawa").setup({
      commentStyle = { italic = false },
      keywordStyle = { italic = false },
      overrides = function()
        return {
          -- snacks.picker のパス（ディレクトリ部分）は既定だと NonText 相当で見辛いため、
          -- Directory（crystalBlue）に揃えて視認性を上げる
          SnacksPickerDir = { link = "Directory" },
        }
      end,
    })
    require("kanagawa").load("wave")
  end,
}
