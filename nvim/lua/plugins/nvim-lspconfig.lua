return {
  "neovim/nvim-lspconfig",
  -- event = { "BufReadPre" },
  -- FIXME: dependencies を整理する
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/vim-vsnip",
    "hrsh7th/cmp-vsnip",
    "b0o/schemastore.nvim",
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
    lspconfig.lua_ls.setup({})
    lspconfig.rust_analyzer.setup({
      settings = {
        ["rust-analyzer"] = {
          diagnostics = {
            enable = false,
          },
        },
      },
    })
    lspconfig.gopls.setup({})
    lspconfig.intelephense.setup({})
    lspconfig.yamlls.setup({
      settings = {
        yaml = {
          schemas = require("schemastore").yaml.schemas(),
          validate = true,
          format = { enable = true },
        },
      },
    })
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
      "<cmd>lua vim.lsp.buf.formatting()<CR>",
    },
    {
      mode = "n",
      "gr",
      "<cmd>Telescope lsp_references<CR>",
    },
    {
      mode = "n",
      "gd",
      "<cmd>lua vim.lsp.buf.definition()<CR>",
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
