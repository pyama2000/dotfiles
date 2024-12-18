vim.opt.number = true
vim.opt.title = true
vim.opt.mouse = ""
vim.opt.clipboard:append({ "unnamedplus" })
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.list = true
vim.opt.listchars = { tab = "»-", trail = "-", extends = "»", precedes = "«", nbsp = "%" }
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"

vim.opt.autoread = true
vim.cmd([[
  augroup autoreload-checktime
    autocmd CursorHold,CursorHoldI,CursorMoved,CursorMovedI,BufEnter * silent! checktime
  augroup END
]])
-- ファイルタイプごとのインデント設定
vim.cmd([[
  augroup indent
    " Terraform
    autocmd FileType terraform setlocal expandtab tabstop=2 shiftwidth=2
    autocmd FileType terraform-vars setlocal expandtab tabstop=2 shiftwidth=2
    autocmd FileType tf setlocal expandtab tabstop=2 shiftwidth=2
  augroup END
]])

if vim.fn.exists("+termguicolors") then
  vim.opt.termguicolors = true
end
