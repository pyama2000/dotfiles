return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    local diagnostics = null_ls.builtins.diagnostics
    local formatting = null_ls.builtins.formatting

    null_ls.setup({
      diagnostics_format = "[#{c}] #{m} (#{s})",
      sources = {
        diagnostics.actionlint,
        diagnostics.buf,
        diagnostics.golangci_lint,
        diagnostics.fish,
        diagnostics.hadolint,
        diagnostics.opacheck,
        diagnostics.sqlfluff.with({
          extra_args = { "--dialect", "mysql" },
        }),
        diagnostics.terraform_validate,
        diagnostics.tfsec,
        diagnostics.yamllint.with({
          extra_args = { "--config-data", "{ extends: relaxed, rules: { line-length: { max: 120 } } }" },
        }),
        formatting.buf,
        formatting.fish_indent,
        formatting.goimports,
        formatting.prettier.with({
          prefer_local = "node_modules/.bin",
        }),
        formatting.rego,
        formatting.shfmt.with({
          extra_args = { "--indent", "2", "--case-indent", "--binary-next-line", "--simplify" },
        }),
        formatting.sqlfluff.with({
          extra_args = { "--dialect", "mysql" },
        }),
        formatting.stylua,
      },
    })
  end,
}
