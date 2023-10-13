return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      open_mapping = [[<c-\>]],
      shade_terminals = false,
      -- add --login so ~/.zprofile is loaded
      -- https://vi.stackexchange.com/questions/16019/neovim-terminal-not-reading-bash-profile/16021#16021
      shell = 'zsh --login',
    }
  end,
  keys = {
    { [[<C-\>]] },
    { '<leader>0', '<Cmd>2ToggleTerm<Cr>', desc = 'Terminal #2' },
    {
      '<leader>td',
      '<cmd>ToggleTerm size=40 dir=~/Desktop direction=horizontal<cr>',
      desc = 'Open a horizontal terminal at the Desktop directory',
    },
    {
      '<leader>tv',
      function()
        local count = vim.v.count1
        require('toggleterm').toggle(count, 0, vim.loop.cwd(), 'vertical')
      end,
      desc = 'ToggleTerm (vertical)',
    },
    {
      '<leader>th',
      function()
        local count = vim.v.count1
        require('toggleterm').toggle(count, 10, vim.loop.cwd(), 'horizontal')
      end,
      desc = 'ToggleTerm (horizontal)',
    },
  },
}
