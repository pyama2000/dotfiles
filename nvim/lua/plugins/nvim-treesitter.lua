return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  config = function()
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      ensure_installed = { "lua", "vim", "go", "rust", "sql", "terraform" },
      highlight = {
        enable = true,
      },
    })
  end,
}
