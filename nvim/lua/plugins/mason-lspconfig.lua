return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
      }),
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      }),
    })

    require("mason")

    local nvim_lsp = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
      ensure_installed = {
        -- "rust_analyzer",
        "lua_ls",
        -- "jsonls",
      },
    })
    mason_lspconfig.setup_handlers({
      function(server_name)
        local opts = {}
        nvim_lsp[server_name].setup(opts)
      end,
    })
  end,
}
