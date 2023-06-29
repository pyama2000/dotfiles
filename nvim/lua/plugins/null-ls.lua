return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    local diagnostics = null_ls.builtins.diagnostics
    local formatting = null_ls.builtins.formatting

    null_ls.setup({
      sources = {
        diagnostics.actionlint,
        diagnostics.buf,
        diagnostics.golangci_lint,
        diagnostics.fish,
        diagnostics.hadolint,
        diagnostics.ruff,
        diagnostics.terraform_validate,
        diagnostics.tfsec,
        diagnostics.typos,
        diagnostics.yamllint,
        formatting.buf,
        formatting.fish_indent,
        formatting.goimports,
        formatting.shfmt,
        formatting.stylua,
        formatting.ruff,
      },
    })
  end,
}
