return {
  "lambdalisue/fern.vim",
  event = { "VeryLazy" },
  config = function()
    vim.keymap.set("n", "<C-n>", "<cmd>Fern . -reveal=% -drawer -toggle<CR>", { noremap = true, silent = true })
  end,
}
