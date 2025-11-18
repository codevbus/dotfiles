-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
  },
  {
    'catppuccin/nvim',
    tag = 'stable',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = true,
        term_colors = true,
        integrations = {
          telescope = {
            enabled = true,
          },
          treesitter = true,
          gitsigns = true,
          mason = true,
          notify = true,
          fidget = true,
          noice = true,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
        },
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'Harpoon [A]dd file' })
      vim.keymap.set('n', '<leader>hm', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = '[H]arpoon [M]enu' })

      -- Quick jump to positions 1-4 (avoids collision with <C-h> for tmux-navigator)
      vim.keymap.set('n', '<leader>h1', function()
        harpoon:list():select(1)
      end, { desc = '[H]arpoon file 1' })
      vim.keymap.set('n', '<leader>h2', function()
        harpoon:list():select(2)
      end, { desc = '[H]arpoon file 2' })
      vim.keymap.set('n', '<leader>h3', function()
        harpoon:list():select(3)
      end, { desc = '[H]arpoon file 3' })
      vim.keymap.set('n', '<leader>h4', function()
        harpoon:list():select(4)
      end, { desc = '[H]arpoon file 4' })

      -- Cycle through harpoon list
      vim.keymap.set('n', '<leader>hn', function()
        harpoon:list():next()
      end, { desc = '[H]arpoon [N]ext' })
      vim.keymap.set('n', '<leader>hp', function()
        harpoon:list():prev()
      end, { desc = '[H]arpoon [P]rev' })
    end,
  },
  {
    'stevearc/oil.nvim',
    opts = {
      columns = { 'icon' },
      view_options = {
        show_hidden = true,
      },
    },
    keys = {
      { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
    },
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff' },
      { '<leader>gD', '<cmd>DiffviewClose<cr>', desc = '[G]it [D]iff close' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it [H]istory (current file)' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = '[G]it [H]istory (all files)' },
    },
  },
  {
    'github/copilot.vim',
  },

  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },

  {
    'codevbus/git-remote.nvim',
    branch = 'update_dir_structure',
  },

  -- TODO move to custom commands init
  vim.keymap.set('n', '<leader>sj', require('telescope.builtin').jumplist, { desc = '[S]earch [J]umplist' }),
  -- Normal mode bind formats the current line number.
  vim.keymap.set('n', '<leader>ww', '<cmd>lua require("git_remote").openLine()<CR>', { silent = true, desc = 'Open remote git URL in browser' }),
  vim.keymap.set('n', '<leader>wy', '<cmd>lua require("git_remote").yankLine()<CR>', { silent = true, desc = 'Yank remote git URL' }),
  -- Visual mode bind formats with the selected lines.
  vim.keymap.set('v', '<leader>ww', '<esc><cmd>lua require("git_remote").openSelection()<CR>', { silent = true, desc = 'Open remote git URL in browser' }),
  vim.keymap.set('v', '<leader>wy', '<esc><cmd>lua require("git_remote").yankSelection()<CR>', { silent = true, desc = 'Yank remote git URL' }),
}
