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
| [blink.cmp](https://github.com/saghen/blink.cmp) | Completion engine (LSP, snippets, buffer) |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Snippet collection |
| [copilot.vim](https://github.com/github/copilot.vim) | GitHub Copilot AI completion (ghost text) |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | File explorer, fuzzy finder, terminal, lazygit |
| [mini.diff](https://github.com/nvim-mini/mini.diff) | Git diff visualization |
| [mini.statusline](https://github.com/nvim-mini/mini.statusline) | Minimal statusline |
| [mini.pairs](https://github.com/nvim-mini/mini.pairs) | Auto pairs (brackets, quotes) |
| [mini.trailspace](https://github.com/nvim-mini/mini.trailspace) | Trailing whitespace highlight/trim |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Code formatter (format on save) |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP server manager |
| [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Mason and LSP integration |
| [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | Auto-install formatters |
| [SchemaStore.nvim](https://github.com/b0o/SchemaStore.nvim) | JSON/YAML schema catalog |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting via tree-sitter |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | TODO/FIXME highlighting and navigation |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua functions library (dependency) |

## Keymaps

Leader key is `<Space>`.

### General

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>w` | Normal | Save file |
| `<leader>W` | Normal | Save file (no format) |
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

### File Explorer (snacks.nvim)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>e` | Normal | Toggle file explorer |
| `l` / `<CR>` | Explorer | Open file / toggle directory |
| `h` | Explorer | Close directory |
| `<BS>` | Explorer | Go up one directory |
| `a` | Explorer | Add new file/folder |
| `d` | Explorer | Delete |
| `r` | Explorer | Rename |
| `y` | Explorer | Yank file paths |
| `p` | Explorer | Paste |

### Fuzzy Finder & Terminal (snacks.nvim)

| Key | Mode | Description |
|-----|------|-------------|
| `<C-p>` | Normal | Find files |
| `<C-g>` | Normal | Live grep |
| `<C-\>` | Normal/Terminal | Toggle floating terminal |

### Lazygit (snacks.nvim)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gg` | Normal | Open Lazygit |
| `<leader>gl` | Normal | Lazygit log |
| `<leader>gf` | Normal | Lazygit file log |

### Git Diff (mini.diff)

| Key | Mode | Description |
|-----|------|-------------|
| `[h` | Normal | Jump to previous hunk |
| `]h` | Normal | Jump to next hunk |
| `[H` | Normal | Jump to first hunk |
| `]H` | Normal | Jump to last hunk |

### TODO Comments (todo-comments.nvim)

| Key | Mode | Description |
|-----|------|-------------|
| `]t` | Normal | Jump to next TODO |
| `[t` | Normal | Jump to previous TODO |

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
| `<leader>f` | Normal | Format (conform.nvim) |
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
| `eslint` | JavaScript / TypeScript (linting) |
| `yamlls` | YAML |
| `jsonls` | JSON |
| `bashls` | Bash / Shell |
| `tailwindcss` | Tailwind CSS |
| `gh_actions_ls` | GitHub Actions |
| `terraformls` | Terraform |

## Formatters

The following formatters are automatically installed via Mason:

| Formatter | Language |
|-----------|----------|
| `stylua` | Lua |
| `goimports` | Go |
| `prettier` | JavaScript / TypeScript / JSON / YAML |
| `biome` | JavaScript / TypeScript / JSON (when biome.json exists) |
| `shfmt` | Shell |

## License

[MIT](./LICENSE)
