---@type vim.lsp.Config
return {
  filetypes = { "terraform", "terraform-vars", "tf" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(bufnr, ".terraform")
    on_dir(root or vim.fs.dirname(fname))
  end,
  on_attach = function(client, _bufnr)
    -- terraform-ls の semantic tokens は大きなファイルで Neovim をフリーズさせるため無効化
    client.server_capabilities.semanticTokensProvider = nil
  end,
}
