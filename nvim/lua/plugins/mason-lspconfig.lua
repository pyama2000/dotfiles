return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason")

    local nvim_lsp = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
      ensure_installed = {
        "bashls",
        "bufls",
        "rust_analyzer",
        "lua_ls",
        "gopls",
        "jsonls",
        "yamlls",
        "terraformls",
        "tflint",
        "pyright",
      },
    })
    mason_lspconfig.setup_handlers({
      function(server_name)
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        nvim_lsp[server_name].setup({
          capabilities = capabilities,
        })
      end,
    })
  end,
}
