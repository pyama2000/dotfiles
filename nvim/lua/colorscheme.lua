local ok, _ = pcall(require, "kanagawa")
if not ok then
  return
end

vim.opt.termguicolors = true
vim.cmd("colorscheme kanagawa")
