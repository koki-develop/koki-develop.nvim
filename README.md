# Neovim Configuration

## Requirements

- Neovim 0.11+

## Installation

```bash
git clone https://github.com/koki-develop/koki-develop.nvim.git ~/.config/nvim
```

Plugins will be automatically installed on first launch.

## Plugins

| Plugin | Description |
|--------|-------------|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Colorscheme (style: night) |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Display buffers as tabs |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File type icons |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | File explorer |
| [blink.cmp](https://github.com/saghen/blink.cmp) | Completion engine (LSP, snippets, buffer) |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Snippet collection |
| [copilot.vim](https://github.com/github/copilot.vim) | GitHub Copilot AI completion (ghost text) |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Terminal management |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | Fuzzy finder |
| [mini.diff](https://github.com/nvim-mini/mini.diff) | Git diff visualization |
| [mini.statusline](https://github.com/nvim-mini/mini.statusline) | Minimal statusline |
| [mini.pairs](https://github.com/nvim-mini/mini.pairs) | Auto pairs (brackets, quotes) |
| [mini.trailspace](https://github.com/nvim-mini/mini.trailspace) | Trailing whitespace highlight/trim |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP server manager |
| [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Mason and LSP integration |

## Keymaps

Leader key is `<Space>`.

### General

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Quit |
| `<leader>h` | Normal | Clear search highlight |
| `<leader>tw` | Normal | Trim trailing whitespace |

### Window Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `<C-h>` | Normal | Move to left window |
| `<C-j>` | Normal | Move to lower window |
| `<C-k>` | Normal | Move to upper window |
| `<C-l>` | Normal | Move to right window |

### Buffer Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `<S-h>` | Normal | Previous buffer |
| `<S-l>` | Normal | Next buffer |
| `<leader>x` | Normal | Close buffer |

### Line Movement

| Key | Mode | Description |
|-----|------|-------------|
| `J` | Visual | Move selection down |
| `K` | Visual | Move selection up |

### File Explorer (nvim-tree)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>e` | Normal | Toggle file explorer |

Operations inside the tree:
- `a`: Create new file/folder
- `d`: Delete
- `r`: Rename
- `x`: Cut
- `c`: Copy
- `p`: Paste
- `?`: Show help

### Fuzzy Finder (fzf-lua)

| Key | Mode | Description |
|-----|------|-------------|
| `<C-p>` | Normal | Find files |
| `<C-g>` | Normal | Live grep |

### Terminal (toggleterm)

| Key | Mode | Description |
|-----|------|-------------|
| `<C-\>` | Normal/Terminal | Toggle terminal |
| `<leader>th` | Normal | Open horizontal terminal |
| `<leader>tv` | Normal | Open vertical terminal |
| `<leader>tf` | Normal | Open floating terminal |
| `<Esc>` | Terminal | Exit terminal mode |

### Git Diff (mini.diff)

| Key | Mode | Description |
|-----|------|-------------|
| `[h` | Normal | Jump to previous hunk |
| `]h` | Normal | Jump to next hunk |
| `[H` | Normal | Jump to first hunk |
| `]H` | Normal | Jump to last hunk |

### Completion (blink.cmp)

| Key | Mode | Description |
|-----|------|-------------|
| `<C-y>` | Insert | Accept completion |
| `<C-n>` | Insert | Next completion item |
| `<C-p>` | Insert | Previous completion item |
| `<C-e>` | Insert | Close completion menu |

### LSP

| Key | Mode | Description |
|-----|------|-------------|
| `gd` | Normal | Go to definition |
| `gD` | Normal | Go to declaration |
| `gi` | Normal | Go to implementation |
| `gr` | Normal | Show references |
| `K` | Normal | Hover documentation |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal | Code action |
| `<leader>f` | Normal | Format |
| `[d` | Normal | Jump to previous diagnostic |
| `]d` | Normal | Jump to next diagnostic |
| `<leader>d` | Normal | Show diagnostic details |

## LSP Servers

The following LSP servers are automatically installed via Mason:

| Server | Language |
|--------|----------|
| `lua_ls` | Lua |
| `gopls` | Go |
| `ts_ls` | TypeScript / JavaScript |

## License

[MIT](./LICENSE)
