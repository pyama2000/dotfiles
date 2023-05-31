vim.opt.number = true
vim.opt.title = true
vim.opt.mouse = ""
vim.opt.clipboard:append({ "unnamedplus" })
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.list = true
vim.opt.listchars = { tab = "»-", trail = "-", extends = "»", precedes = "«", nbsp = "%" }

--Always show the signcolumn, otherwise it would shift the text each time
vim.opt.signcolumn = "yes"

if vim.fn.exists("+termguicolors") then
  vim.opt.termguicolors = true
end
