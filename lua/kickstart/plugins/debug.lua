-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
--
local continue = function()
  require('dap.ext.vscode').load_launchjs(nil,
    { node = { "javascript", "typescript" } })
  require('dap').continue()
end

return {
  {
    -- NOTE: Yes, you can install new plugins here!
    'mfussenegger/nvim-dap',
    -- NOTE: And you can specify dependencies as well
    dependencies = {
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',

      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

      -- Add your own debuggers here
      'leoluz/nvim-dap-go',

      "mxsdev/nvim-dap-vscode-js",
      "microsoft/vscode-js-debug",
      {
        'Joakker/lua-json5',
        build = "./install.sh"
      },
      {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
          "mfussenegger/nvim-dap",
        },
        config = function(_, opts)
          local path = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python'
          require('dap-python').setup(path)
        end
      },
      'Weissle/persistent-breakpoints.nvim'
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('dap-vscode-js').setup({
        node_path = 'node',
        debugger_path = os.getenv('HOME') .. '/.DAP/vscode-js-debug',
        adapters = { 'node', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      })

      require('telescope').load_extension('dap')

      -- require('mason-nvim-dap').setup {
      --   -- Makes a best effort to setup the various debuggers with
      --   -- reasonable debug configurations
      --   automatic_setup = true,
      --
      --   -- You can provide additional configuration to the handlers,
      --   -- see mason-nvim-dap README for more information
      --   handlers = {},
      --
      --   -- You'll need to check that you have the required things installed
      --   -- online, please don't ask me how to install them :)
      --   ensure_installed = {
      --     -- Update this to ensure that you have the debuggers for the langs you want
      --     'delve',
      --     'node',
      --     'pwa-node'
      --   },
      -- }

      require('dap.ext.vscode').json_decode = require 'json5'.parse


      -- Basic debugging keymaps, feel free to change to your liking!
      -- vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      -- vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      -- vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      -- vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })

      -- Basic debugging keymaps, feel free to change to your liking!
      -- vim.keymap.set('n', '<leader>dc', continue, { desc = 'Debug: Start/Continue' })
      -- vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
      -- vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step Over' })
      -- vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      -- vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      -- vim.keymap.set('n', '<leader>B', function()
      --   dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      -- end, { desc = 'Debug: Set Breakpoint' })

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      vim.keymap.set('n', '<F7>', function()
        require('dapui').toggle({ reset = true })
      end, { desc = 'Dap UI' })

      vim.keymap.set({ 'n', 'v' }, '<leader>de', require('dapui').eval, { desc = 'Eval' })

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Install golang specific config
      require('dap-go').setup()
    end,
    keys = {
      {
        "<leader>B",
        function() require('persistent-breakpoints.api').set_conditional_breakpoint() end,
        desc =
        "Breakpoint Condition"
      },
      {
        "<leader>b",
        function() require('persistent-breakpoints.api').toggle_breakpoint() end,
        desc =
        "Toggle Breakpoint"
      },
      {
        "<leader>dc",
        function() require('persistent-breakpoints.api').clear_all_breakpoints() end,
        desc =
        "Clear Breakpoints"
      },
      {
        "<F5>",
        function() continue() end,
        desc =
        "Continue"
      },
      {
        "<leader>dC",
        function() require("dap").run_to_cursor() end,
        desc =
        "Run to Cursor"
      },
      {
        "<leader>dg",
        function() require("dap").goto_() end,
        desc =
        "Go to line (no execute)"
      },
      {
        "<F1>",
        function() require("dap").step_into() end,
        desc =
        "Step Into"
      },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end,   desc = "Up" },
      {
        "<leader>dl",
        -- function() require("dap").run_last() end,
        function() require('telescope.extensions.dap').list_breakpoints() end,
        desc =
        "Run Last"
      },
      {
        "<F3>",
        function() require("dap").step_out() end,
        desc =
        "Step Out"
      },
      {
        "<F2>",
        function() require("dap").step_over() end,
        desc =
        "Step Over"
      },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      {
        "<leader>dr",
        function() require("dap").repl.toggle() end,
        desc =
        "Toggle REPL"
      },
      {
        "<leader>ds",
        function() require("dap").session() end,
        desc =
        "Session"
      },
      {
        "<leader>dt",
        function() require("dap").terminate() end,
        desc =
        "Terminate"
      },
      {
        "<leader>dw",
        function() require("dap.ui.widgets").hover() end,
        desc =
        "Widgets"
      },
    },
  },
  {
    'Weissle/persistent-breakpoints.nvim',
    event = "BufReadPost",
    config = function()
      require('persistent-breakpoints').setup({
        load_breakpoints_event = { "BufReadPost" }
      })
    end,
  }
}
