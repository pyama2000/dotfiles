return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.tfsec,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.actionlint,
        null_ls.builtins.formatting.ruff,
      },
    })
  end,
}
