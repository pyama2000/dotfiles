return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    "j-hui/fidget.nvim",
    "b0o/schemastore.nvim",
  },
  config = function()
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
      function()
        require("snacks").picker.lsp_references()
      end,
    },
    {
      mode = "n",
      "gd",
      function()
        require("snacks").picker.lsp_definitions()
      end,
    },
    {
      mode = "n",
      "gt",
      "<cmd>lua vim.lsp.buf.type_definition()<CR>",
    },
    {
      mode = "n",
      "gi",
      function()
        require("snacks").picker.lsp_implementations()
      end,
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
      function()
        require("snacks").picker.diagnostics()
      end,
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
