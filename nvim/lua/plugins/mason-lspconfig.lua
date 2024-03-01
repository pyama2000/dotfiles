return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "lukas-reineke/lsp-format.nvim",
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "b0o/schemastore.nvim",
  },
  config = function()
    local mason_lspconfig = require("mason-lspconfig")
    local lspconfig = require("lspconfig")
    local lsp_format = require("lsp-format")

    require("mason").setup({})
    lsp_format.setup({})

    mason_lspconfig.setup({
      ensure_installed = {
        "bashls",
        "bufls",
        "gopls",
        "intelephense",
        "jsonls",
        "lua_ls",
        "pyright",
        "ruff_lsp",
        "rust_analyzer",
        "terraformls",
        "tflint",
        "tsserver",
        "yamlls",
      },
    })

    mason_lspconfig.setup_handlers({
      function(server_name)
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local opts = { capabilities = capabilities }

        if server_name == "lua_ls" then
          opts.on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end
        end

        if server_name == "rust_analyzer" then
          opts.settings = {
            ["rust-analyzer"] = {
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },
              cargo = {
                buildScripts = {
                  enable = true,
                },
                features = "all",
              },
              procMacro = {
                enable = true,
              },
            },
          }
        end

        if server_name == "terraformls" or server_name == "tflint" then
          opts.on_attach = lsp_format.on_attach
          opts.filetypes = { "terraform", "terraform-vars", "tf" }
        end

        if server_name == "yamlls" then
          opts.settings = {
            yaml = {
              schemas = require("schemastore").yaml.schemas(),
              validate = true,
              format = { enable = true },
            },
          }
        end

        if server_name == "tsserver" then
          opts.on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end
        end

        lspconfig[server_name].setup(opts)
      end,
    })
  end,
}
