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
    'github/copilot.vim',
  },

  'christoomey/vim-tmux-navigator',

  -- TODO move to custom commands init
  vim.keymap.set('n', '<leader>sj', require('telescope.builtin').jumplist, { desc = '[S]earch [J]umplist' }),
}
