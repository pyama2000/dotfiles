---@type vim.lsp.Config
return {
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
      options = {
        home_manager = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."default".options',
        },
      },
    },
  },
}
