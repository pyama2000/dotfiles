return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-file-browser.nvim",
        config = function()
          require("telescope").load_extension("file_browser")
        end,
      },
    },
    event = "VeryLazy",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          mappings = {
            n = {
              ["<ECS>"] = actions.close,
              ["q"] = actions.close,
            },
            i = {
              ["<ECS>"] = actions.close,
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
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-d>f", builtin.find_files, { noremap = true, silent = true })
      vim.keymap.set("n", "<C-d>b", builtin.buffers, { noremap = true, silent = true })
      vim.keymap.set("n", "<C-d>l", builtin.live_grep, { noremap = true, silent = true })
      vim.keymap.set("n", "<C-d>r", builtin.resume, { noremap = true, silent = true })
      vim.keymap.set("n", "<C-d>c", builtin.command_history, { noremap = true, silent = true })
      vim.keymap.set("n", "<C-d>s", builtin.search_history, { noremap = true, silent = true })
      vim.keymap.set({ "n", "x" }, "<C-d>g", builtin.grep_string, { noremap = true, silent = true })
      vim.keymap.set("n", "<C-d>h", "<cmd>Telescope find_files --hidden=true<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<C-d>of", "<cmd>Telescope find_files ", { noremap = true, silent = true })
      vim.keymap.set("n", "<C-f>b", telescope.extensions.file_browser.file_browser, { noremap = true, silent = true })
    end,
  },
}
