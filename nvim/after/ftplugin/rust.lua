local bufnr = vim.api.nvim_get_current_buf()
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
vim.keymap.set("n", "<F3>", function()
  vim.cmd.RustLsp("codeAction")
end, { silent = true, buffer = bufnr })
vim.keymap.set("n", "K", function()
  vim.cmd.RustLsp({ "hover", "actions" })
end, { silent = true, buffer = bufnr })