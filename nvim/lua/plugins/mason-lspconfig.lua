return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local mason_lspconfig = require("mason-lspconfig")
    local lspconfig = require("lspconfig")

    require("mason").setup({})

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
        local opts = { capabilities = capabilities }
        lspconfig[server_name].setup(opts)
      end,
    })
  end,
}
