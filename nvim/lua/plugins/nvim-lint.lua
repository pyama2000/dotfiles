return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      dockerfile = { "hadolint" },
      terraform = { "trivy" },
    }

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function(args)
        lint.try_lint(nil, { ignore_errors = true })
        -- actionlint は GitHub Actions のワークフローファイルのみ対象（yaml 全体には掛けない）
        if vim.api.nvim_buf_get_name(args.buf):match("%.github/workflows/") then
          lint.try_lint("actionlint")
        end
      end,
    })
  end,
}
