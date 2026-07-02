return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    -- main ブランチの setup() は install_dir しか受け付けないため、パーサーは明示的にインストールする
    require("nvim-treesitter").install({
      "bash",
      "dockerfile",
      "fish",
      "go",
      "hcl",
      "javascript",
      "json",
      "kotlin",
      "lua",
      "markdown",
      "markdown_inline",
      "nix",
      "proto",
      "python",
      "rust",
      "terraform",
      "toml",
      "tsx",
      "typescript",
      "yaml",
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
      callback = function(args)
        -- パーサーが無い filetype はネイティブのハイライト・インデントを維持する
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
