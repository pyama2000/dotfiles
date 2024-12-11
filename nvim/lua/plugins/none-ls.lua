return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local nls = require("null-ls")
    local diagnostics = nls.builtins.diagnostics
    local formatting = nls.builtins.formatting
    nls.setup({
      diagnostics_format = "[#{c}] #{m} (#{s})",
      sources = {
        -- diagnostics
        diagnostics.actionlint,
        diagnostics.hadolint,
        diagnostics.terraform_validate,
        diagnostics.trivy.with({
          args = { "config", "--format", "json", "$DIRNAME" },
        }),
        -- formatting
        formatting.shfmt.with({
          extra_args = { "--indent", "2", "--case-indent", "--binary-next-line", "--simplify" },
        }),
        formatting.stylua,
      },
      on_attach = function(client, buffer)
        -- formatting on save
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = buffer })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = buffer,
            callback = function()
              vim.lsp.buf.format({ async = true })
            end,
          })
        end
      end,
    })
  end,
}
