return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  opts = {
    ensure_installed = { "lua", "vim", "go", "rust", "sql", "terraform" },
    highlight = {
      enable = true,
    },
  },
}
