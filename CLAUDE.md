# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration repository using lazy.nvim as the plugin manager. The configuration follows a modular structure for better organization and maintainability.

## Directory Structure

```
~/.config/nvim/
├── init.lua                      # Entry point (loads config modules)
├── lua/
│   ├── config/
│   │   ├── options.lua           # vim.opt settings
│   │   ├── keymaps.lua           # Key mappings (non-plugin)
│   │   ├── autocmds.lua          # Autocommands
│   │   └── lazy.lua              # lazy.nvim bootstrap & plugin loading
│   └── plugins/
│       ├── ui.lua                # Colorscheme, bufferline, statusline, icons
│       ├── editor.lua            # File explorer, fuzzy finder, terminal, git diff
│       ├── coding.lua            # Completion, AI, auto-pairs, formatting
│       └── lsp.lua               # LSP servers, Mason, diagnostics
├── CLAUDE.md
└── renovate.json
```

## File Responsibilities

### Core Config (lua/config/)
- **options.lua** - Core Neovim settings (line numbers, indentation, search, display, splits, clipboard, file handling, performance)
- **keymaps.lua** - Non-plugin keybindings (window navigation `C-hjkl`, search `<leader>h`, line movement `J/K`, save `<leader>w`/`<leader>W`, quit `<leader>q`)
- **autocmds.lua** - Autocommands (checktime for file changes, yank highlight)
- **lazy.lua** - lazy.nvim bootstrap, plugin loading, and auto-sync on startup

### Plugins (lua/plugins/)
- **ui.lua** - Visual appearance
  - tokyonight.nvim (colorscheme, style: night)
  - bufferline.nvim (buffer tabs, `S-h`/`S-l` cycle, `<leader>x` close)
  - mini.statusline (statusline)
- **editor.lua** - File navigation and tools
  - snacks.nvim (explorer `<leader>e`, picker `<C-p>`/`<C-g>`, terminal `<C-\>`, lazygit `<leader>gg`/`<leader>gl`/`<leader>gf`)
  - mini.diff (git diff signs, `[h`/`]h`/`[H`/`]H` navigation)
- **coding.lua** - Code editing support
  - blink.cmp (completion, `C-y` accept, `C-n`/`C-p` navigate)
  - copilot.vim (AI completion)
  - mini.surround (surround actions, `sa` add, `sd` delete, `sr` replace)
  - mini.pairs (auto brackets)
  - mini.trailspace (trailing whitespace, `<leader>tw` trim)
  - conform.nvim (formatter, `<leader>f`, format_on_save)
  - todo-comments.nvim (TODO/FIXME highlighting, `]t`/`[t` navigation)
- **lsp.lua** - Language Server Protocol
  - nvim-lspconfig + mason.nvim + mason-lspconfig.nvim
  - mason-tool-installer.nvim + SchemaStore.nvim
  - LSP keybindings (`gd`, `gD`, `gi`, `gr`, `K`, `<leader>rn`, `<leader>ca`, `[d`/`]d`, `<leader>d`)

## Key Conventions

- 2-space indentation for Lua
- Leader key is space
- Plugins are managed via lazy.nvim with lazy-loading support
- No swap files (uses undo files + version control instead)
- Prefer minimal configurations over complex setups
- Do not use conventional commits (e.g., `feat:`, `fix:`) for commit messages

## lazy.nvim: opts vs config

Prefer `opts` over `config` when possible:

```lua
-- Good: Use opts for simple setup
opts = {
  option1 = true,
  option2 = "value",
},

-- Good: Use opts function for dynamic values
opts = function()
  return { ... }
end,

-- Required: Use config when additional logic is needed
config = function()
  require("plugin").setup({ ... })
  vim.cmd.colorscheme("...")  -- Additional commands
  vim.api.nvim_create_autocmd(...)  -- Additional autocmds
end,
```

**Use `config` when:**
- Need to call `vim.cmd` (e.g., colorscheme)
- Need to create autocmds after setup
- Need to call multiple setup functions (e.g., lsp.lua)
- Need custom logic beyond passing options

## Neovim Version

This configuration targets **Neovim 0.11+** and uses modern APIs:
- `vim.uv` instead of `vim.loop` (deprecated)
- `vim.diagnostic.jump({ count = n })` instead of `goto_prev/goto_next` (deprecated)
- `vim.lsp.config()` and `vim.lsp.enable()` for LSP configuration

## Plugin Version Management

- Plugins are pinned to specific commit SHAs with version tags in comments
- Format: `commit = "SHA", -- vX.Y.Z`
- Renovate comment annotations enable automatic updates:
  ```lua
  -- renovate: datasource=github-tags depName=org/repo
  commit = "...", -- vX.Y.Z
  ```
- For plugins without regular releases (e.g., SchemaStore.nvim), use commit-based tracking:
  ```lua
  -- renovate: datasource=git-refs depName=org/repo
  commit = "..."
  ```
- Renovate configuration is in `renovate.json`
- `lazy-lock.json` is gitignored; plugin files in `lua/plugins/` are the source of truth
- Plugins are automatically synced on startup via VimEnter autocmd
- To check the latest version and commit hash of a plugin:
  ```bash
  # For plugins with GitHub releases
  gh api /repos/{owner}/{repo}/releases/latest --jq '{tag_name: .tag_name, target_commitish: .target_commitish}'
  # For plugins without releases (tags only)
  gh api /repos/{owner}/{repo}/tags --jq '.[0] | {name: .name, sha: .commit.sha}'
  ```
- Note: mini.nvim modules are published as separate repos (e.g., `nvim-mini/mini.trailspace`), each with their own commit SHAs

## Testing Changes

To test configuration changes:
- Reload Neovim
- For specific module changes: `:source lua/config/<module>.lua` or `:source lua/plugins/<module>.lua`
- For lazy.nvim changes: `:Lazy` to access the plugin manager UI
