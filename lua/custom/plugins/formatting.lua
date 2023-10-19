return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  optional = true,
  opts = {
    formatters_by_ft = {
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      graphql = { 'prettier' },
      lua = { 'stylua' },
      python = { 'isort', 'black' },
    },
    formatters = {
      prettier = {
        -- exclude the repo /Users/danielmaizel/codefresh/argo-platform
        condition = function(ctx)
          return vim.fs.find({ 'argo-platform' }, { path = ctx.filename, upward = true })[1]
        end,
      },
    },
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    },
  },
  config = function()
    local conform = require('conform')
    vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
      conform.format { lsp_fallback = true, async = false, timeout_ms = 500 }
    end, { desc = 'Format file or range (in visual mode)' })
  end,
}
