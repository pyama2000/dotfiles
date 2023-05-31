return {
  "rebelot/kanagawa.nvim",
  config = function()
    require("kanagawa").load("wave")
    vim.cmd("silent KanagawaCompile")
  end,
}
