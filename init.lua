-- =============================================================================
-- Leader Key Configuration
-- =============================================================================
-- Set leader key before loading any plugins or keymaps.
-- Space is a popular choice as it's easy to reach and rarely conflicts
-- with other mappings.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
-- General Options
-- =============================================================================
local opt = vim.opt

-- -----------------------------------------------------------------------------
-- Line Numbers
-- -----------------------------------------------------------------------------
-- Show absolute line number on the current line and relative numbers
-- on all other lines. This makes it easy to use motions like `5j` or `10k`
-- to jump to specific lines.

opt.number = true
opt.relativenumber = true

-- -----------------------------------------------------------------------------
-- Indentation
-- -----------------------------------------------------------------------------
-- Use 2 spaces for indentation. This is a common convention in many
-- modern codebases (JavaScript, TypeScript, Lua, etc.).
-- - tabstop: Number of spaces a <Tab> character displays as
-- - shiftwidth: Number of spaces used for each step of (auto)indent
-- - expandtab: Convert tabs to spaces when inserting
-- - smartindent: Automatically indent new lines based on syntax

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- -----------------------------------------------------------------------------
-- Search Behavior
-- -----------------------------------------------------------------------------
-- Make search more intuitive:
-- - ignorecase: Case-insensitive search by default
-- - smartcase: If search pattern contains uppercase, become case-sensitive
-- - hlsearch: Highlight all matches
-- - incsearch: Show matches as you type

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- -----------------------------------------------------------------------------
-- Display Settings
-- -----------------------------------------------------------------------------
-- Visual enhancements for better coding experience:
-- - termguicolors: Enable 24-bit RGB colors (required for modern colorschemes)
-- - signcolumn: Always show sign column to prevent layout shift (for git signs, diagnostics)
-- - cursorline: Highlight the current line for easier cursor tracking
-- - scrolloff: Keep N lines visible above/below cursor when scrolling
-- - sidescrolloff: Keep N columns visible left/right of cursor when scrolling horizontally

opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- -----------------------------------------------------------------------------
-- Window Splitting
-- -----------------------------------------------------------------------------
-- When opening new splits:
-- - splitbelow: Horizontal splits open below the current window
-- - splitright: Vertical splits open to the right of the current window
-- This feels more natural for most users (content flows down and right).

opt.splitbelow = true
opt.splitright = true

-- -----------------------------------------------------------------------------
-- System Integration
-- -----------------------------------------------------------------------------
-- - clipboard: Use system clipboard for all yank/paste operations
--   This allows seamless copy/paste between Neovim and other applications.

opt.clipboard = "unnamedplus"

-- -----------------------------------------------------------------------------
-- File Handling
-- -----------------------------------------------------------------------------
-- - undofile: Persist undo history to disk, allowing undo after closing/reopening
-- - swapfile: Disable swap files (we rely on undo files and version control instead)
--   Swap files can be annoying and cause conflicts, especially with version control.

opt.undofile = true
opt.swapfile = false

-- -----------------------------------------------------------------------------
-- Performance Tuning
-- -----------------------------------------------------------------------------
-- - updatetime: Time in ms before CursorHold event fires and swap file writes
--   Lower value means faster response for plugins that use CursorHold (e.g., LSP hover)
-- - timeoutlen: Time in ms to wait for a mapped sequence to complete
--   Affects which-key popup delay and multi-key mappings

opt.updatetime = 250
opt.timeoutlen = 300

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
-- Buffer Navigation
-- -----------------------------------------------------------------------------
-- Use Shift + h/l to cycle through buffers.
-- This provides quick access to recently edited files without
-- needing a buffer picker.

keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer", silent = true })

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
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit file", silent = true })

-- =============================================================================
-- Plugin Manager (lazy.nvim)
-- =============================================================================
-- Bootstrap lazy.nvim if it's not already installed.
-- lazy.nvim is a modern plugin manager that supports lazy-loading,
-- which significantly improves startup time.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=v11.17.5",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- Plugin Setup
-- =============================================================================
-- Initialize lazy.nvim with our plugin specifications.
-- Plugins will be added here as we build out the configuration.

require("lazy").setup({
  -- Plugins will be added here
})
