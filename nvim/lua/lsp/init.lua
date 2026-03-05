vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Bash / Shell Script
vim.lsp.enable("bashls")

-- Docker Compose
-- TODO: Nixでバージョン管理したら
-- Language Server: https://github.com/microsoft/compose-language-service

-- Go
vim.lsp.enable("gopls")
-- Kotlin
vim.lsp.enable("kotlin_language_server")
-- Lua
vim.lsp.enable("lua_ls")
-- Nix
vim.lsp.enable("nixd")

-- PHP
-- TODO: Nixでバージョン管理したら
-- Language Server: https://intelephense.com/

-- Protocol Buffers (buf)
vim.lsp.enable("buf_ls")
-- Python
vim.lsp.enable("ruff")
vim.lsp.enable("pylsp")
-- Terraform
vim.lsp.enable("terraformls")
vim.lsp.enable("tflint")
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})
-- YAML
vim.lsp.enable("yamlls")
-- JavaScript / TypeScript
vim.lsp.enable("ts_ls")
vim.lsp.enable("denols")
vim.lsp.enable("biome")
-- JSON
vim.lsp.enable("jsonls")
