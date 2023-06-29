return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "single",
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
