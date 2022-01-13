lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    ensure_installed = "maintained",
    enable = true,
    disable = {
      'lua',
      'ruby',
      'c_sharp',
      'dockerfile',
    }
  }
}
EOF
