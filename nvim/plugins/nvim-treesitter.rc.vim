lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = {
      'lua',
      'ruby',
      'c_sharp',
      'dockerfile',
    }
  },
  indent = {
    enable = false,
  }
}
EOF
