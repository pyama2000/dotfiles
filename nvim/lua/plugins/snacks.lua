return {
  "folke/snacks.nvim",
  priority = 1000,
  -- netrw の置き換えと picker を起動直後から使えるようにするため遅延ロードしない
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    picker = {
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        explorer = { hidden = true },
      },
      exclude = { ".git" },
    },
    explorer = { enabled = true, replace_netrw = true },
  },
  keys = {
    -- ファイル検索
    {
      "<C-d>f",
      function()
        require("snacks").picker.files()
      end,
      desc = "Find files",
    },
    -- バッファ・履歴検索
    {
      "<C-d>b",
      function()
        require("snacks").picker.buffers({
          current = false,
          win = {
            input = { keys = { ["<C-d>"] = { "bufdelete", mode = { "n", "i" } } } },
            list = { keys = { ["d"] = "bufdelete" } },
          },
        })
      end,
      desc = "Buffers",
    },
    {
      "<C-d>o",
      function()
        require("snacks").picker.recent()
      end,
      desc = "Recent files",
    },
    -- テキスト検索
    {
      "<C-d>l",
      function()
        require("snacks").picker.grep()
      end,
      desc = "Live grep",
    },
    {
      "<C-d>g",
      function()
        require("snacks").picker.grep_word()
      end,
      mode = { "n", "x" },
      desc = "Grep word/selection",
    },
    -- テキスト検索履歴検索
    {
      "<C-d>s",
      function()
        require("snacks").picker.search_history()
      end,
      desc = "Search history",
    },
    -- Vimコマンド履歴検索
    {
      "<C-d>c",
      function()
        require("snacks").picker.command_history()
      end,
      desc = "Command history",
    },
    -- レジスタ検索
    {
      "<C-d>rg",
      function()
        require("snacks").picker.registers()
      end,
      desc = "Registers",
    },
    -- 直前に開いた picker を再度開く
    {
      "<C-d>rs",
      function()
        require("snacks").picker.resume()
      end,
      desc = "Resume picker",
    },
    -- ファイルブラウザ
    {
      "<C-f>b",
      function()
        require("snacks").explorer()
      end,
      desc = "File explorer",
    },
  },
}
