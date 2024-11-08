return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions
      telescope.setup({
        defaults = {
          mappings = {
            n = {
              ["<ECS>"] = actions.close,
              ["q"] = actions.close,
            },
            i = {
              ["<C-c>"] = actions.close,
            },
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
          },
          file_ignore_patterns = {
            ".git/",
          },
        },
        pickers = {
          buffers = {
            ignore_current_buffer = true,
            sort_lastused = true,
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer,
              },
              n = {
                ["d"] = actions.delete_buffer,
              },
            },
          },
          find_files = {
            hidden = true,
          },
        },
        extensions = {
          file_browser = {
            hijack_netrw = true,
            mappings = {
              n = {
                ["cd"] = fb_actions.change_cwd,
                ["cp"] = fb_actions.copy,
                ["cr"] = fb_actions.create,
                ["cw"] = fb_actions.goto_cwd,
                ["rm"] = fb_actions.remove,
                ["rn"] = fb_actions.rename,
                ["."] = fb_actions.toggle_hidden,
              },
            },
          },
        },
      })
      local builtin = require("telescope.builtin")
      -- ファイル検索
      vim.keymap.set("n", "<C-d>f", builtin.find_files, { noremap = true, silent = true })
      -- バッファ・履歴検索
      vim.keymap.set("n", "<C-d>b", builtin.buffers, { noremap = true, silent = true })
      vim.keymap.set("n", "<C-d>o", builtin.oldfiles, { noremap = true, silent = true })
      -- テキスト検索
      vim.keymap.set("n", "<C-d>l", builtin.live_grep, { noremap = true, silent = true })
      vim.keymap.set({ "n", "x" }, "<C-d>g", builtin.grep_string, { noremap = true, silent = true })
      -- テキスト検索履歴検索
      vim.keymap.set("n", "<C-d>s", builtin.search_history, { noremap = true, silent = true })
      -- Vimコマンド履歴検索
      vim.keymap.set("n", "<C-d>c", builtin.command_history, { noremap = true, silent = true })
      -- レジスタ検索
      vim.keymap.set("n", "<C-d>rg", builtin.registers, { noremap = true, silent = true })
      -- ファイルブラウザ
      vim.keymap.set("n", "<C-f>b", telescope.extensions.file_browser.file_browser, { noremap = true, silent = true })
      -- 直前に開いたTelescopeを再度開く
      vim.keymap.set("n", "<C-d>rs", builtin.resume, { noremap = true, silent = true })

      require("telescope").load_extension("file_browser")
    end,
  },
  -- dependencies
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-telescope/telescope-file-browser.nvim", lazy = true },
}
