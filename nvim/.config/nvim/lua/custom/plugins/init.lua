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
          treesitter = true,
          noice = true,
          telescope = {
            enabled = true,
          },
          mason = true,
          notify = true,
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
  'tpope/vim-fugitive',
  'christoomey/vim-tmux-navigator',

  vim.keymap.set('n', '<leader>sj', require('telescope.builtin').jumplist, { desc = '[S]earch [J]umplist' }),
}
