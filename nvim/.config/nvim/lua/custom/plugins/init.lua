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

  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    config = function()
      require('orgmode').setup {
        -- your agenda & default notes
        org_agenda_files = { '~/org/**/*' },
        org_default_notes_file = '~/org/refile.org',

        -- capture templates
        org_capture_templates = {
          j = {
            description = 'Journal / Daily Accomplishments',
            template = table.concat({
              '** %^{Title} \n',
              '  :PROPERTIES:\n',
              '  :CAPTURED: %U\n',
              '  :END:\n',
              '  %?\n',
            }, ''),
            target = '~/org/journal.org',
            datetree = true,
          },
          c = {
            description = 'Code TODO (with link)',
            template = table.concat({
              '* TODO %^{Title} \n',
              '  :PROPERTIES:\n',
              '  :CAPTURED: %U\n',
              '  :SOURCE: %a\n',
              '  :END:\n',
              '%?\n',
            }, ''),
            target = '~/org/code_todo.org',
            datetree = true,
          },
          t = {
            description = 'General TODO',
            template = table.concat({
              '* TODO %^{Title} \n',
              '  :PROPERTIES:\n',
              '  :CAPTURED: %U\n',
              '  :END:\n',
              '%?\n',
            }, ''),
            target = '~/org/todo.org',
          },
          n = {
            description = 'General Note',
            template = table.concat({
              '** %^{Title} \n',
              '  :PROPERTIES:\n',
              '  :CAPTURED: %U\n',
              '  :END:\n',
              '  %?\n',
            }, ''),
            target = '~/org/notes.org',
            datetree = true,
          },
          w = {
            description = 'Weekly Review',
            template = table.concat({
              '\n* Weekly Review – Week %<%V>, %<%Y>\n',
              '  :PROPERTIES:\n',
              '  :REVIEWED: %U\n',
              '  :END:\n\n',
              '  %?',
            }, ''),
            target = '~/org/reviews.org',
          },
        },
      }
    end,
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
