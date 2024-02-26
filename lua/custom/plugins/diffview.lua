return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
  opts = {},
  keys = { { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'DiffView' } },
  config = function()
    require('diffview').setup {
      hooks = {
        diff_buf_win_enter = function(bufnr, winid, ctx)
          if ctx.layout_name:match '^diff2' then
            if ctx.symbol == 'a' then
              vim.opt_local.winhl = table.concat({
                'DiffAdd:DiffviewDiffAddAsDelete',
                'DiffDelete:DiffviewDiffDelete',
              }, ',')
            elseif ctx.symbol == 'b' then
              vim.opt_local.winhl = table.concat({
                'DiffDelete:DiffviewDiffDelete',
              }, ',')
            end
          end
        end,
      },
    }

    vim.keymap.set('n', '<leader>gd', function()
      if next(require('diffview.lib').views) == nil then
        vim.cmd 'DiffviewOpen'
      else
        vim.cmd 'DiffviewClose'
      end
    end)
  end,
}
