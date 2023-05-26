return {
  "neovim/nvim-lspconfig",
  -- event = { "BufReadPre" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },
  -- init = function()
  --   require("core.plugin").on_attach(function(client, bufnr)
  --     local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

  --     require("plugin.nvim-lspconfig.keymaps").on_attach(client, bufnr)
  --     require("plugin.nvim-lspconfig.diagnostic").on_attach(client, bufnr)
  --     require("plugin.nvim-lspconfig.format").on_attach(client, bufnr)

  --     vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  --   end)
  -- end,
  config = function()
    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })
  end,
}
