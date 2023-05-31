return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      direction = "float",
    },
    keys = {
      {
        mode = "n",
        "<C-t>",
        "<cmd>ToggleTerm<CR>",
      },
      {
        mode = "t",
        "<ESC>",
        [[<C-\><C-n>]],
      },
      {
        mode = "t",
        "<C-t>",
        "<cmd>ToggleTerm<CR>",
      },
    },
  },
}
