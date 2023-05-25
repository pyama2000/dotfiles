local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

require("telescope").setup({
  defaults = {
    mappings = {
      ["n"] = {
        ["q"] = actions.close,
      },
    },
  },
  extensions = {
    file_browser = {},
  },
})
require("telescope").load_extension("file_browser")

vim.keymap.set("n", "<C-f>b", telescope.extensions.file_browser.file_browser, { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>f", builtin.find_files, { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>b", builtin.buffers, { noremap = true, silent = true })

return {}
