---@type vim.lsp.Config
return {
  filetypes = { "terraform", "terraform-vars", "tf" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(bufnr, ".terraform")
    on_dir(root or vim.fs.dirname(fname))
  end,
}
