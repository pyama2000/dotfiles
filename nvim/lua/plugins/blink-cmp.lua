return {
  "saghen/blink.cmp",
  -- リリースタグを追うことでビルド済みの Rust fuzzy matcher バイナリを利用する
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-c>"] = { "cancel", "fallback" },
    },
    -- 補完候補の選択時にドキュメントを自動表示する（nvim-cmp と同等の挙動）
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
    signature = { enabled = true },
    sources = { default = { "lsp", "path", "buffer" } },
    cmdline = { keymap = { preset = "cmdline" } },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
