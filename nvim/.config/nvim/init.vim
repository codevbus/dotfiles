set nu
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set relativenumber
set nohlsearch
set hidden
set exrc
set noerrorbells
set noswapfile
set nobackup
set undofile
set undodir=~/.vim/undodir
set incsearch
set scrolloff=8
set colorcolumn=80
set signcolumn=yes
set completeopt=menu,menuone,noselect

" Plugins
call plug#begin('~/.local/share/nvim/site/autoload')
" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Appearance
Plug 'navarasu/onedark.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Misc
Plug 'TimUntersberger/neogit'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'tami5/lspsaga.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'fladson/vim-kitty'
call plug#end()

colorscheme onedark
highlight Normal guibg=none
let g:airline_powerline_fonts = 1

" Remaps
let mapleader = " "
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>sb :lua require'telescope.builtin'.current_buffer_fuzzy_find()<CR>
nnoremap <leader>sd :lua require'telescope.builtin'.live_grep()<CR>
nnoremap <leader>sg :lua require'telescope.builtin'.git_files()<CR>
nnoremap <leader>pf :lua require'telescope.builtin'.find_files()<CR>
nnoremap <leader>bb :lua require'telescope.builtin'.buffers()<CR>
nnoremap <leader>gg :lua require'neogit'.open()<CR>
nnoremap <leader>bi :ls<CR>
nnoremap <leader>b[ :bprev<CR>
nnoremap <leader>b] :bnext<CR>

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup ONSAVE
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END

lua require("lsp")
lua require'nvim-treesitter.configs'.setup { highlight = { enable = true}, incremental_selection = { enable = true }, textobjects = { enable = true }}
