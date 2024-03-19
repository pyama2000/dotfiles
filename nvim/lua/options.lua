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
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.signcolumn = "yes"

-- Auto reload file
vim.opt.autoread = true
vim.cmd([[
  augroup autoreload-checktime
    autocmd CursorHold,CursorHoldI,CursorMoved,CursorMovedI,BufEnter * silent! checktime
  augroup END
]])

if vim.fn.exists("+termguicolors") then
  vim.opt.termguicolors = true
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})
