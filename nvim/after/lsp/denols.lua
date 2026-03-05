---@type vim.lsp.Config
return {
  root_markers = {
    "deno.json",
    "deno.jsonc",
    "deps.ts",
  },
  -- Node (ts_ls) とDeno (denols) の競合を避けるための設定
  workspace_required = true,
}
