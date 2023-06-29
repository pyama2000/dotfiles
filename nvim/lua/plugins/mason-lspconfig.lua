return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "b0o/schemastore.nvim",
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

        if server_name == "yamlls" then
          opts.settings = {
            yaml = {
              schemas = require("schemastore").yaml.schemas(),
              validate = true,
              format = { enable = true },
            },
          }
        end

        lspconfig[server_name].setup(opts)
      end,
    })
  end,
}
