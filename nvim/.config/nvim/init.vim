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

" Plugins
call plug#begin('~/.local/share/nvim/site/autoload')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'navarasu/onedark.nvim'
Plug 'TimUntersberger/neogit'
call plug#end()

colorscheme onedark
highlight Normal guibg=none

" Remaps
let mapleader = " "
nnoremap <leader>sb :lua require'telescope.builtin'.current_buffer_fuzzy_find()<CR>
nnoremap <leader>sd :lua require'telescope.builtin'.live_grep()<CR>
nnoremap <leader>sg :lua require'telescope.builtin'.git_files()<CR>
nnoremap <leader>pf :lua require'telescope.builtin'.find_files()<CR>
nnoremap <leader>bb :lua require'telescope.builtin'.buffers()<CR>
nnoremap <leader>gg :lua require'neogit'.open()<CR>
nnoremap <leader>bi :ls<CR>


fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup ONSAVE
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END
