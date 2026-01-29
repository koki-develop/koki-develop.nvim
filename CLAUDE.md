# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration repository. The entire configuration is contained in a single `init.lua` file using lazy.nvim as the plugin manager.

## Architecture

The `init.lua` file is organized into these sections (in order):
1. **Leader Key Configuration** - Sets space as leader/localleader
2. **General Options** - Core Neovim settings (line numbers, indentation, search, display, splits, clipboard, file handling, performance)
3. **Key Mappings** - Custom keybindings for window/buffer navigation, search, line movement, and file operations
4. **Plugin Manager Bootstrap** - lazy.nvim installation (pinned to v11.17.5)
5. **Plugin Setup** - `require("lazy").setup({...})` block for plugin specifications
   - **LSP Support** - mason.nvim + mason-lspconfig.nvim + nvim-lspconfig with automatic_enable

## Key Conventions

- 2-space indentation for Lua
- Leader key is space
- Plugins are managed via lazy.nvim with lazy-loading support
- No swap files (uses undo files + version control instead)
- Prefer minimal configurations over complex setups

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
- Renovate configuration is in `renovate.json`

## Testing Changes

To test configuration changes, reload Neovim or run `:source %` on the init.lua file. For lazy.nvim changes, use `:Lazy` to access the plugin manager UI.
