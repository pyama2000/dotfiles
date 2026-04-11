return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local nls = require("null-ls")
    local diagnostics = nls.builtins.diagnostics
    local formatting = nls.builtins.formatting
    local trivy_severities = {
      CRITICAL = vim.diagnostic.severity.ERROR,
      HIGH = vim.diagnostic.severity.ERROR,
      MEDIUM = vim.diagnostic.severity.WARN,
      LOW = vim.diagnostic.severity.INFO,
      UNKNOWN = vim.diagnostic.severity.INFO,
    }

    local normalize_trivy_filename = function(filename, cwd)
      if not filename or filename == "" then
        return filename
      end

      if vim.startswith(filename, "/") then
        return vim.fs.normalize(filename)
      end

      return vim.fs.normalize(vim.fs.joinpath(cwd, filename))
    end

    -- none-ls' builtin trivy source can keep stale diagnostics when Trivy returns relative Targets.
    local trivy = diagnostics.trivy.with({
      on_output = function(params)
        local combined_diagnostics = {}
        local cwd = vim.fs.normalize(params.cwd)

        if params.source_id ~= nil then
          local namespace = require("null-ls.diagnostics").get_namespace(params.source_id)
          local old_diagnostics = vim.diagnostic.get(nil, { namespace = namespace })

          for _, old_diagnostic in ipairs(old_diagnostics) do
            local old_filename = normalize_trivy_filename(old_diagnostic.filename, cwd)

            if not old_filename or not vim.startswith(old_filename, cwd) then
              table.insert(combined_diagnostics, old_diagnostic)
            end
          end
        end

        for _, result in pairs(params.output.Results or {}) do
          local filename = normalize_trivy_filename(result.Target, cwd)

          for _, misconfiguration in ipairs(result.Misconfigurations or {}) do
            table.insert(combined_diagnostics, {
              code = misconfiguration.ID,
              message = misconfiguration.Title,
              row = misconfiguration.CauseMetadata.StartLine,
              end_row = misconfiguration.CauseMetadata.EndLine,
              col = 0,
              source = "trivy",
              severity = trivy_severities[misconfiguration.Severity],
              filename = filename,
            })
          end
        end

        return combined_diagnostics
      end,
    })

    nls.setup({
      diagnostics_format = "[#{c}] #{m} (#{s})",
      sources = {
        -- diagnostics
        diagnostics.actionlint,
        diagnostics.hadolint,
        diagnostics.terraform_validate,
        trivy,
        -- formatting
        -- formatting.shfmt.with({
        --   extra_args = { "--indent", "2", "--case-indent", "--binary-next-line", "--simplify" },
        -- }),
        formatting.stylua,
      },
      on_attach = function(client, buffer)
        -- formatting on save
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = buffer })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = buffer,
            callback = function()
              vim.lsp.buf.format({ async = true })
            end,
          })
        end
      end,
    })
  end,
}
