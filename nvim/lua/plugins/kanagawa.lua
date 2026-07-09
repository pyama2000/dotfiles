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
          -- Terraform のリソース参照（google_service_account 等）は @variable.builtin で
          -- 既定 italic。色（special2）は維持して italic だけ無効化する
          ["@variable.builtin"] = { italic = false },
        }
      end,
    })
    require("kanagawa").load("wave")
  end,
}
