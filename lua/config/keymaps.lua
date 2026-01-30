-- =============================================================================
-- Key Mappings
-- =============================================================================
local keymap = vim.keymap.set

-- -----------------------------------------------------------------------------
-- Window Navigation
-- -----------------------------------------------------------------------------
-- Use Ctrl + hjkl to move between windows instead of Ctrl-w + hjkl.
-- This is faster and more ergonomic for frequent window switching.

keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- -----------------------------------------------------------------------------
-- Search
-- -----------------------------------------------------------------------------
-- Clear search highlighting with <leader>h.
-- This is more convenient than typing :nohlsearch every time.

keymap("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight", silent = true })

-- -----------------------------------------------------------------------------
-- Line Movement (Visual Mode)
-- -----------------------------------------------------------------------------
-- Move selected lines up/down with J/K in visual mode.
-- The `=gv` part re-indents the moved lines and re-selects them.

keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

-- -----------------------------------------------------------------------------
-- File Operations
-- -----------------------------------------------------------------------------
-- Quick save and quit with leader key.
-- These are common operations that benefit from shorter keymaps.

keymap("n", "<leader>w", ":w<CR>", { desc = "Save file", silent = true })
keymap("n", "<leader>W", ":noautocmd w<CR>", { desc = "Save file (no format)", silent = true })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit file", silent = true })
