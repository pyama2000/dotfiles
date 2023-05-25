local ok, _ = pcall(require, "nvim-treesitter")
if not ok then
  return
end

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
})

return {}
