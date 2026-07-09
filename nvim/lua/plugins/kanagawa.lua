return {
  "rebelot/kanagawa.nvim",
  config = function()
    require("kanagawa").setup({
      overrides = function()
        return {
          -- snacks.picker のパス（ディレクトリ部分）は既定だと NonText 相当で見辛いため、
          -- Directory（crystalBlue）に揃えて視認性を上げる
          SnacksPickerDir = { link = "Directory" },
        }
      end,
    })
    require("kanagawa").load("wave")

    -- italic はグループ個別（keyword/comment/@variable.builtin ...）に散らばっており
    -- 潰し切れないため、colorscheme 読み込み後に全グループから italic 属性を剥がす。
    -- 色・リンクは保持され、italic だけ無効になる。
    for name, def in pairs(vim.api.nvim_get_hl(0, {})) do
      if def.italic then
        def.italic = false
        vim.api.nvim_set_hl(0, name, def)
      end
    end
  end,
}
