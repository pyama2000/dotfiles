---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      workspace = {
        library = {
          vim.env.VIMRUNTIME .. "/lua",
        },
      },
    },
  },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
}
