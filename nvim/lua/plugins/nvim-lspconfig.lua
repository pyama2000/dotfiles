return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "j-hui/fidget.nvim",
    "b0o/schemastore.nvim",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Bash
    -- TODO: Nixでバージョン管理したら
    -- Language Server: https://github.com/bash-lsp/bash-language-server

    -- Docker Compose
    -- TODO: Nixでバージョン管理したら
    -- Language Server: https://github.com/microsoft/compose-language-service

    -- Go
    lspconfig.gopls.setup({ capabilities = capabilities })

    -- Lua
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
      end,
    })

    -- PHP
    -- TODO: Nixでバージョン管理したら
    -- Language Server: https://intelephense.com/

    -- Protocol Buffers (buf)
    lspconfig.buf_ls.setup({ capabilities = capabilities })

    -- Python
    lspconfig.ruff.setup({ capabilities = capabilities })

    -- Terraform
    lspconfig.terraformls.setup({
      capabilities = capabilities,
      filetypes = { "terraform", "terraform-vars", "tf" },
    })
    lspconfig.tflint.setup({
      capabilities = capabilities,
      filetypes = { "terraform", "terraform-vars", "tf" },
    })
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      pattern = { "*.tf", "*.tfvars" },
      callback = function()
        vim.lsp.buf.format()
      end,
    })

    -- YAML
    lspconfig.yamlls.setup({
      capabilities = capabilities,
      settings = {
        yaml = {
          schemas = require("schemastore").yaml.schemas(),
          validate = true,
          format = { enable = true },
        },
      },
    })

    -- Kotlin
    lspconfig.kotlin_language_server.setup({})

    require("fidget").setup({})
  end,
  keys = {
    {
      mode = "n",
      "K",
      "<cmd>lua vim.lsp.buf.hover()<CR>",
    },
    {
      mode = "n",
      "gf",
      "<cmd>lua vim.lsp.buf.format()<CR>",
    },
    {
      mode = "n",
      "gr",
      "<cmd>Telescope lsp_references<CR>",
    },
    {
      mode = "n",
      "gd",
      "<cmd>Telescope lsp_definitions<CR>",
    },
    {
      mode = "n",
      "gt",
      "<cmd>lua vim.lsp.buf.type_definition()<CR>",
    },
    {
      mode = "n",
      "gi",
      "<cmd>Telescope lsp_implementations<CR>",
    },
    {
      mode = "i",
      "<C-k>",
      "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    },
    {
      mode = "n",
      "gk",
      "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    },
    {
      mode = "n",
      "ga",
      "<cmd>Telescope diagnostics<CR>",
    },
    {
      mode = "n",
      "<F2>",
      "<cmd>lua vim.lsp.buf.rename()<CR>",
    },
    {
      mode = "n",
      "<F3>",
      "<cmd>lua vim.lsp.buf.code_action()<CR>",
    },
    {
      mode = "n",
      "ge",
      "<cmd>lua vim.diagnostic.open_float()<CR>",
    },
    {
      mode = "n",
      "g[",
      "<cmd>lua vim.diagnostic.goto_prev()<CR>",
    },
    {
      mode = "n",
      "g]",
      "<cmd>lua vim.diagnostic.goto_next()<CR>",
    },
  },
}
