return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
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
        "gopls",
        "jsonls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "terraformls",
        "tflint",
        "yamlls",
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
