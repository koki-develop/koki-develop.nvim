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
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
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
  -- ==========================================================================
  -- UI Enhancements
  -- ==========================================================================
  -- Bufferline: Display open buffers as tabs at the top of the editor.
  -- This provides a familiar tab-like interface for navigating between buffers.
  {
    "akinsho/bufferline.nvim",
    -- renovate: datasource=github-tags depName=akinsho/bufferline.nvim
    commit = "655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3", -- v4.9.1
    event = "VeryLazy",
    dependencies = {
      -- renovate: datasource=github-tags depName=nvim-tree/nvim-web-devicons
      { "nvim-tree/nvim-web-devicons", commit = "5b9067899ee6a2538891573500e8fd6ff008440f" }, -- v0.100
    },
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<leader>x", "<cmd>bdelete<CR>", desc = "Close buffer" },
    },
    config = function()
      require("bufferline").setup({
        options = {
          separator_style = "thin", -- Thin separator for a cleaner look
          show_buffer_close_icons = false, -- Hide close icons on tabs
          show_close_icon = false, -- Hide close icon for entire bufferline
          show_buffer_icons = true, -- Show filetype icons
          diagnostics = "nvim_lsp", -- Show LSP diagnostics indicator
        },
      })
    end,
  },

  -- ==========================================================================
  -- File Explorer
  -- ==========================================================================
  -- nvim-tree.lua: A file explorer tree for neovim.
  -- Toggle with <leader>e, navigate with standard vim motions.
  -- Basic operations in the tree:
  --   a: Create new file/folder    d: Delete    r: Rename
  --   x: Cut    c: Copy    p: Paste    ?: Show help
  {
    "nvim-tree/nvim-tree.lua",
    -- renovate: datasource=github-tags depName=nvim-tree/nvim-tree.lua
    commit = "a0db8bf7d6488b1dcd9cb5b0dfd6684a1e14f769", -- v1.15.0
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    },
    -- -------------------------------------------------------------------------
    -- Disable Netrw (init runs BEFORE plugin loads)
    -- -------------------------------------------------------------------------
    -- Netrw is Neovim's built-in file explorer. We disable it to prevent
    -- conflicts with nvim-tree. This must be done before nvim-tree loads,
    -- so we use `init` instead of `config`. The `init` function is called
    -- during startup, even before the plugin is loaded via lazy-loading.
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    -- -------------------------------------------------------------------------
    -- nvim-tree Setup (config runs AFTER plugin loads)
    -- -------------------------------------------------------------------------
    config = function()
      require("nvim-tree").setup({
        -- ---------------------------------------------------------------------
        -- View Settings
        -- ---------------------------------------------------------------------
        -- Configure how the file tree window is displayed.
        -- - width: Width of the tree window in columns (default: 30)
        view = {
          width = 30,
        },

        -- ---------------------------------------------------------------------
        -- Filter Settings
        -- ---------------------------------------------------------------------
        -- Configure which files are hidden in the tree.
        -- - dotfiles: When true, files starting with '.' are hidden
        -- Note: Press 'H' in the tree to toggle dotfiles visibility on the fly.
        filters = {
          dotfiles = false, -- Show dotfiles (hidden files)
        },

        -- Other options use sensible defaults:
        -- - renderer.icons.show: file/folder/git icons enabled by default
        -- - sort.sorter: "name" (alphabetical) by default
        -- - git integration: enabled by default
      })
    end,
  },

  -- ==========================================================================
  -- AI Completion
  -- ==========================================================================
  -- GitHub Copilot: AI-powered code completion and suggestions.
  -- After installation, run :Copilot setup to authenticate with GitHub.
  {
    "github/copilot.vim",
    -- renovate: datasource=github-tags depName=github/copilot.vim
    commit = "a12fd5672110c8aa7e3c8419e28c96943ca179be", -- v1.59.0
  },

  -- ==========================================================================
  -- LSP Support
  -- ==========================================================================
  -- This configuration sets up Language Server Protocol (LSP) support using
  -- three complementary plugins:
  --
  -- - mason.nvim: A portable package manager for Neovim that manages external
  --   editor tooling such as LSP servers, DAP servers, linters, and formatters.
  --   It provides a nice UI accessible via :Mason command.
  --
  -- - mason-lspconfig.nvim: Bridges mason.nvim with nvim-lspconfig, enabling
  --   automatic installation and setup of LSP servers. It ensures that servers
  --   specified in `ensure_installed` are automatically downloaded and configured.
  --
  -- - nvim-lspconfig: Provides default configurations for various LSP servers,
  --   making it easy to set up language servers with sensible defaults.
  {
    "neovim/nvim-lspconfig",
    -- renovate: datasource=github-tags depName=neovim/nvim-lspconfig
    commit = "5bfcc89fd155b4ffc02d18ab3b7d19c2d4e246a7", -- v2.5.0
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- renovate: datasource=github-tags depName=mason-org/mason.nvim
      { "mason-org/mason.nvim", commit = "44d1e90e1f66e077268191e3ee9d2ac97cc18e65" }, -- v2.2.1
      -- renovate: datasource=github-tags depName=mason-org/mason-lspconfig.nvim
      { "mason-org/mason-lspconfig.nvim", commit = "f2fa60409630ec2d24acf84494fb55e1d28d593c" }, -- v2.1.0
    },
    config = function()
      -- -----------------------------------------------------------------------
      -- Mason Setup
      -- -----------------------------------------------------------------------
      -- Initialize mason.nvim with default settings.
      -- This must be called before mason-lspconfig setup.
      require("mason").setup()

      -- -----------------------------------------------------------------------
      -- Mason-LSPConfig Setup
      -- -----------------------------------------------------------------------
      -- Configure automatic installation and enabling of LSP servers.
      --
      -- - ensure_installed: List of LSP servers that will be automatically
      --   installed when Neovim starts if they are not already present.
      --
      -- - automatic_enable: When set to true (Neovim 0.11+), installed servers
      --   are automatically enabled via vim.lsp.enable(). This means you don't
      --   need to manually call setup() for each server.
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", -- Lua language server (for Neovim config and Lua projects)
          "gopls",  -- Go language server (official Google implementation)
          "ts_ls",  -- TypeScript/JavaScript language server
        },
        automatic_enable = true,
      })

      -- -----------------------------------------------------------------------
      -- Lua Language Server Configuration
      -- -----------------------------------------------------------------------
      -- Configure lua_ls to recognize Neovim's Lua API (vim.* functions).
      -- This enables completions and hover documentation for Neovim development.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
            },
          },
        },
      })

      -- -----------------------------------------------------------------------
      -- LSP Keybindings
      -- -----------------------------------------------------------------------
      -- Set up buffer-local keybindings when an LSP server attaches to a buffer.
      -- These keybindings are only active in buffers where LSP is available,
      -- ensuring they don't interfere with normal editing in non-LSP buffers.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf, silent = true }

          -- Navigation
          -- gd: Jump to where the symbol under cursor is defined (implementation)
          -- gD: Jump to where the symbol is declared (e.g., header file in C/C++)
          --     Note: In many languages, declaration and definition are the same
          -- gi: Jump to the implementation of an interface or abstract method
          -- gr: Show all references to the symbol under cursor
          -- K:  Show hover documentation for the symbol under cursor
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

          -- Refactoring
          -- <leader>rn: Rename the symbol under cursor across all references
          -- <leader>ca: Show available code actions (quick fixes, refactorings)
          -- <leader>f:  Format the current buffer using the LSP formatter
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)

          -- Diagnostics
          -- [d: Jump to the previous diagnostic (error, warning, hint)
          -- ]d: Jump to the next diagnostic
          -- <leader>d: Show diagnostic details in a floating window
          vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
          vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        end,
      })
    end,
  },
})

-- =============================================================================
-- Auto Sync Plugins
-- =============================================================================
-- Automatically sync plugins on startup to ensure they match the commit SHAs
-- specified in init.lua. This is useful when Renovate updates the commit SHAs.

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("lazy").sync({ wait = false, show = false })
  end,
})
