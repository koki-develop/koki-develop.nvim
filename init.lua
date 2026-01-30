-- =============================================================================
-- Leader Key Configuration
-- =============================================================================
-- Set leader key before loading any plugins or keymaps.
-- Space is a popular choice as it's easy to reach and rarely conflicts
-- with other mappings.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
-- Load Configuration Modules
-- =============================================================================
-- Configuration is split into separate modules for better organization:
-- - config.options: vim.opt settings (line numbers, indentation, etc.)
-- - config.keymaps: Key mappings (window navigation, file operations, etc.)
-- - config.autocmds: Autocommands (file change detection, plugin sync, etc.)
-- - config.lazy: Plugin manager (lazy.nvim) bootstrap and plugin loading

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
