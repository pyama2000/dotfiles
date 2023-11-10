return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    local diagnostics = null_ls.builtins.diagnostics
    local formatting = null_ls.builtins.formatting
    -- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
      diagnostics_format = "[#{c}] #{m} (#{s})",
      sources = {
        diagnostics.actionlint,
        diagnostics.buf,
        diagnostics.golangci_lint,
        diagnostics.fish,
        diagnostics.hadolint,
        diagnostics.opacheck,
        -- diagnostics.ruff,
        -- diagnostics.sqlfluff.with({
        --   extra_args = { "--dialect", "mysql" },
        -- }),
        diagnostics.terraform_validate,
        diagnostics.tfsec,
        -- diagnostics.yamllint.with({
        --   extra_args = { "--config-data", "{ extends: relaxed, rules: { line-length: { max: 120 } } }" },
        -- }),
        formatting.buf,
        formatting.fish_indent,
        formatting.goimports,
        formatting.jq,
        formatting.prettier.with({
          prefer_local = "node_modules/.bin",
        }),
        formatting.rego,
        formatting.shfmt.with({
          extra_args = { "--indent", "2", "--case-indent", "--binary-next-line", "--simplify" },
        }),
        -- formatting.sqlfluff.with({
        --   extra_args = { "--dialect", "mysql" },
        -- }),
        formatting.stylua,
        -- formatting.ruff,
      },
      -- on_attach = function(client, bufnr)
      --   if client.supports_method("textDocument/formatting") then
      --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       group = augroup,
      --       buffer = bufnr,
      --       callback = function()
      --         vim.lsp.buf.format({
      --           bufnr = bufnr,
      --           filter = function(c)
      --             return c.name == "null-ls"
      --           end,
      --         })
      --       end,
      --     })
      --   end
      -- end,
    })
  end,
}
