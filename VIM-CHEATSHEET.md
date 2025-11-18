# Vim/Neovim Cheatsheet

Quick reference for tmux-heavy DevOps workflow (Python, Terraform, Docker, AWS)

---

## 🚀 Installed Plugins

### Harpoon - File Bookmarking

| Key | Action |
|-----|--------|
| `<leader>a` | Add current file to harpoon |
| `<leader>hm` | Toggle harpoon menu |
| `<leader>h1` | Jump to harpoon file 1 |
| `<leader>h2` | Jump to harpoon file 2 |
| `<leader>h3` | Jump to harpoon file 3 |
| `<leader>h4` | Jump to harpoon file 4 |
| `<leader>hn` | Next harpoon file |
| `<leader>hp` | Previous harpoon file |

### Oil.nvim - Filesystem Editing

| Key | Action |
|-----|--------|
| `-` | Open parent directory |
| `dd` | Delete file (in Oil buffer) |
| `cw` | Rename file (in Oil buffer) |
| `yy` / `p` | Copy/paste file (in Oil buffer) |
| `:w` | Apply changes (in Oil buffer) |

### Diffview - Git Diffs

| Key | Action |
|-----|--------|
| `<leader>gd` | Open git diff view |
| `<leader>gD` | Close git diff view |
| `<leader>gh` | Git history for current file |
| `<leader>gH` | Git history for all files |

### Telescope - Fuzzy Finding

| Key | Action |
|-----|--------|
| `<leader>sf` | Search files (with hidden) |
| `<leader>sg` | Live grep |
| `<leader>sw` | Search word under cursor |
| `<leader>sb` | Search git branches |
| `<leader>sc` | Search command history |
| `<leader>sm` | Search marks |
| `<leader>st` | Search treesitter symbols |
| `<leader>sj` | Search jumplist |
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>sd` | Search diagnostics |
| `<leader>sr` | Resume last search |
| `<leader>s.` | Search recent files |
| `<leader><leader>` | Find buffers |
| `<leader>gc` | Git commits |
| `<leader>gs` | Git status |

### Fugitive - Git Integration

| Command | Action |
|---------|--------|
| `:G` | Git status window |
| `:G blame` | Git blame |
| `:G diff` | Git diff |
| `:G log` | Git log |

### Neo-tree - File Explorer

| Key | Action |
|-----|--------|
| `<C-n>` | Toggle Neo-tree |

### Vim-tmux-navigator

| Key | Action |
|-----|--------|
| `<C-h>` | Navigate left (vim/tmux) |
| `<C-j>` | Navigate down (vim/tmux) |
| `<C-k>` | Navigate up (vim/tmux) |
| `<C-l>` | Navigate right (vim/tmux) |

---

## 📍 Marks

### Local Marks (within file)

| Key | Action |
|-----|--------|
| `ma` | Set mark 'a' at cursor |
| `'a` | Jump to mark 'a' |
| `` `a `` | Jump to exact position of mark 'a' |
| `]'` | Jump to next line with mark |
| `['` | Jump to previous line with mark |

### Global Marks (across files)

| Key | Action |
|-----|--------|
| `mA` | Set global mark 'A' |
| `'A` | Jump to mark 'A' (any file) |
| **Example usage:** | |
| `mT` | Mark terraform main file |
| `mD` | Mark docker-compose file |
| `mP` | Mark python entry point |
| `'T` | Jump to terraform main |

### Special Marks

| Key | Action |
|-----|--------|
| `` `. `` | Jump to last change |
| `` `" `` | Jump to last exit position |
| `` `[ `` | Jump to start of last change/yank |
| `` `] `` | Jump to end of last change/yank |

---

## 🎯 Text Objects

### Motion Commands

| Key | Action |
|-----|--------|
| `{` / `}` | Jump between paragraphs/blocks |
| `[(` / `])` | Jump to previous/next unmatched `(` |
| `[{` / `]}` | Jump to previous/next unmatched `{` |

### Text Object Actions

| Key | Action |
|-----|--------|
| `dap` | Delete around paragraph |
| `=ap` | Auto-indent paragraph |
| `vip` | Visual select inside paragraph |
| `ci"` | Change inside quotes |
| `da(` | Delete around parentheses |
| `vi{` | Visual select inside braces |
| `di{` | Delete inside dict/braces |
| `di[` | Delete inside list/brackets |
| `yiw` | Yank inner word |
| `ciw` | Change inner word |

---

## 🔍 Navigation

### Jump List

| Key | Action |
|-----|--------|
| `<C-o>` | Jump to older position (back) |
| `<C-i>` | Jump to newer position (forward) |
| `g;` | Jump to last change position |
| `g,` | Jump to next change position |
| `<C-^>` | Toggle between current and alternate file |

### Go-to Commands

| Key | Action |
|-----|--------|
| `gd` | Go to definition (local scope) |
| `gD` | Go to global definition |
| `gf` | Go to file under cursor |
| `gx` | Open URL under cursor in browser |
| `gg` | Go to first line |
| `G` | Go to last line |
| `10G` | Go to line 10 |

---

## 📋 Registers

### Special Registers

| Register | Contains |
|----------|----------|
| `"0` | Last yank (not delete!) |
| `"+` | System clipboard |
| `"%` | Current file path |
| `":` | Last command |
| `"/` | Last search |

### Register Operations

| Key | Action |
|-----|--------|
| `:reg` | View all registers |
| `"0p` | Paste last yank (safe paste) |
| `"+yy` | Yank line to system clipboard |
| `"+p` | Paste from system clipboard |
| `<C-r>%` | Insert current file path (insert/command mode) |

---

## 🎬 Macros

### Recording and Playback

| Key | Action |
|-----|--------|
| `qa` | Start recording to register 'a' |
| `q` | Stop recording |
| `@a` | Replay macro 'a' |
| `@@` | Replay last macro |
| `100@a` | Run macro 'a' 100 times |

### Example: Convert print() to logger.info()

```vim
qa              " Record
/print<CR>      " Find print
ci(             " Change inside parentheses
logger.info(<C-r>0)  " Paste what was deleted
<Esc>           " Normal mode
n               " Next match
q               " Stop
@a              " Repeat for next occurrence
```

---

## 🔤 LSP (Language Server)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `K` | Show hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` | Go to previous diagnostic |
| `]d` | Go to next diagnostic |

---

## 🎨 Visual Mode

### Visual Selection

| Key | Action |
|-----|--------|
| `v` | Visual character mode |
| `V` | Visual line mode |
| `<C-v>` | Visual block mode |
| `gv` | Reselect last visual selection |
| `o` | Toggle cursor to other end of selection |

### Visual Mode Operations

| Key | Action |
|-----|--------|
| `>` | Indent |
| `<` | Unindent |
| `=` | Auto-indent |
| `~` | Toggle case |
| `u` | Lowercase |
| `U` | Uppercase |

---

## 🪟 Windows & Buffers

### Window Management

| Key | Action |
|-----|--------|
| `<C-w>s` | Split horizontal |
| `<C-w>v` | Split vertical |
| `<C-w>q` | Quit window |
| `<C-w>o` | Close all other windows |
| `<C-w>=` | Equalize window sizes |
| `<C-w>_` | Maximize height |
| `<C-w>\|` | Maximize width |

### Buffer Navigation

| Key | Action |
|-----|--------|
| `:bn` | Next buffer |
| `:bp` | Previous buffer |
| `:bd` | Delete buffer |
| `:ls` | List buffers |

---

## 🔧 Editing

### Indentation

| Key | Action |
|-----|--------|
| `>>` | Indent line |
| `<<` | Unindent line |
| `=ap` | Auto-indent paragraph |
| `gg=G` | Auto-indent entire file |

### Case Conversion

| Key | Action |
|-----|--------|
| `~` | Toggle case of character |
| `gU{motion}` | Uppercase |
| `gu{motion}` | Lowercase |
| `gUU` | Uppercase line |
| `guu` | Lowercase line |

### Copy/Paste

| Key | Action |
|-----|--------|
| `yy` | Yank line |
| `Y` | Yank to end of line |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `ddp` | Swap current line with next |

---

## 🔎 Search & Replace

### Search

| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `*` | Search word under cursor (forward) |
| `#` | Search word under cursor (backward) |

### Replace

| Command | Action |
|---------|--------|
| `:s/old/new/` | Replace first on line |
| `:s/old/new/g` | Replace all on line |
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace all with confirmation |
| `:5,12s/old/new/g` | Replace in lines 5-12 |

---

## 🧰 DevOps Shell Aliases

### FZF Functions

```bash
# Project jumping
p() { cd $(find ~/projects -maxdepth 1 -type d | fzf) }

# Quick edit with preview
v() { nvim $(fzf --preview 'bat --color=always {}') }

# Git branch switcher
gb() { git branch -a | grep -v HEAD | sed 's/^..//' | fzf | xargs git checkout }

# AWS profile switcher
awsp() { export AWS_PROFILE=$(grep -o "\[.*\]" ~/.aws/config | tr -d "[]" | fzf) }
```

---

## 💡 Tips

- **Use Harpoon for your 4-5 core files** - Much faster than telescope
- **Uppercase marks for project navigation** - Mark key files globally
- **Macros for repetitive edits** - Record once, replay many times
- **Text objects for efficient editing** - `dap`, `ci"`, `di{` etc.
- **Visual block mode for columnar edits** - `<C-v>` then `I` or `A`
- **`<C-^>` to toggle files** - Quick switch between two files
- **`"0p` for safe paste** - Paste your yank even after deleting
