return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  lazy = false,
  config = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {},
      -- LSP configuration
      server = {
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
              features = "all",
            },
            procMacro = {
              enable = true,
            },
            diagnostics = {
              disabled = { "inactive-code" },
            },
            check = {
              command = "clippy",
            },
          },
        },
      },
      -- DAP configuration
      dap = {},
    }
  end,
}
