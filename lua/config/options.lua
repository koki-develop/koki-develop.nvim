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
-- - autoread: Automatically reload files when changed externally
--   Combined with checktime autocmd to detect changes without relying on focus events

opt.undofile = true
opt.swapfile = false
opt.autoread = true

-- -----------------------------------------------------------------------------
-- Performance Tuning
-- -----------------------------------------------------------------------------
-- - updatetime: Time in ms before CursorHold event fires and swap file writes
--   Lower value means faster response for plugins that use CursorHold (e.g., LSP hover)
-- - timeoutlen: Time in ms to wait for a mapped sequence to complete
--   Affects which-key popup delay and multi-key mappings

opt.updatetime = 250
opt.timeoutlen = 1000
