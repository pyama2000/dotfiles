return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre" },
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
  config = function()
    local lspconfig = require("lspconfig")
    lspconfig.bashls.setup({})
    lspconfig.bufls.setup({})
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
    local custom_attach = function(client, bufnr)
      print("hello")
    end
    lspconfig.terraformls.setup({
      on_attach = custom_attach,
    })
    lspconfig.tflint.setup({})
    lspconfig.pyright.setup({})
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "single",
    })
    -- FIXME: on_attach が効かないので全ての client で format を有効にする
    vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
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
