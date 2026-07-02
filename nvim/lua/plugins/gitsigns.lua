return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")
      vim.keymap.set("n", "]c", function()
        gitsigns.nav_hunk("next")
      end, { buffer = bufnr, desc = "Next hunk" })
      vim.keymap.set("n", "[c", function()
        gitsigns.nav_hunk("prev")
      end, { buffer = bufnr, desc = "Previous hunk" })
      vim.keymap.set("n", "<Space>hp", gitsigns.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
      vim.keymap.set("n", "<Space>hr", gitsigns.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
    end,
  },
}
