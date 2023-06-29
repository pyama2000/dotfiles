return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    local diagnostics = null_ls.builtins.diagnostics
    local formatting = null_ls.builtins.formatting
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
      diagnostics_format = "[#{c}] #{m} (#{s})",
      sources = {
        diagnostics.actionlint,
        diagnostics.buf,
        diagnostics.golangci_lint,
        diagnostics.fish,
        diagnostics.hadolint,
        diagnostics.ruff,
        diagnostics.terraform_validate,
        diagnostics.tfsec,
        diagnostics.yamllint,
        formatting.buf,
        formatting.fish_indent,
        formatting.goimports,
        formatting.shfmt,
        formatting.stylua,
        formatting.ruff,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(c)
                  return c.name == "null-ls"
                end,
              })
            end,
          })
        end
      end,
    })
  end,
}
