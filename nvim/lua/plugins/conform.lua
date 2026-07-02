return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
    },
    format_on_save = function(bufnr)
      -- terraform は terraform-ls にフォーマットさせる（旧 lua/lsp/init.lua の BufWritePre autocmd を統合）
      local lsp_format_filetypes = { terraform = true, ["terraform-vars"] = true, tf = true }
      if lsp_format_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 2000, lsp_format = "prefer" }
      end
      -- それ以外は宣言済みフォーマッタのみ実行し、LSP による予期しない保存時フォーマットを避ける
      return { timeout_ms = 2000, lsp_format = "never" }
    end,
  },
}
