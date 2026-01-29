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

-- - diagnostic virtual_text: Show diagnostic messages inline at the end of lines
vim.diagnostic.config({
  virtual_text = true,
})

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

vim.api.nvim_create_autocmd({ "CursorHold", "BufEnter" }, {
  command = "checktime",
})

-- -----------------------------------------------------------------------------
-- Performance Tuning
-- -----------------------------------------------------------------------------
-- - updatetime: Time in ms before CursorHold event fires and swap file writes
--   Lower value means faster response for plugins that use CursorHold (e.g., LSP hover)
-- - timeoutlen: Time in ms to wait for a mapped sequence to complete
--   Affects which-key popup delay and multi-key mappings

opt.updatetime = 250
opt.timeoutlen = 1000

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
  -- Colorscheme
  -- ==========================================================================
  -- tokyonight.nvim: A clean, dark Neovim theme with vibrant colors.
  -- Popular choice for LunarVim and similar configurations.
  -- Styles available: night, storm, day, moon (default)
  {
    "folke/tokyonight.nvim",
    -- renovate: datasource=github-tags depName=folke/tokyonight.nvim
    commit = "545d72cde6400835d895160ecb5853874fd5156d", -- v4.14.1
    config = function()
      require("tokyonight").setup({
        style = "night", -- "night", "storm", "day", or "moon"
        terminal_colors = true,
      })
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- ==========================================================================
  -- UI Enhancements
  -- ==========================================================================
  -- Bufferline: Display open buffers as tabs at the top of the editor.
  -- This provides a familiar tab-like interface for navigating between buffers.
  {
    "akinsho/bufferline.nvim",
    -- renovate: datasource=github-tags depName=akinsho/bufferline.nvim
    commit = "655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3", -- v4.9.1
    lazy = false,
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
          git_ignored = false, -- Show gitignored files
        },

        -- Other options use sensible defaults:
        -- - renderer.icons.show: file/folder/git icons enabled by default
        -- - sort.sorter: "name" (alphabetical) by default
        -- - git integration: enabled by default
      })
    end,
  },

  -- ==========================================================================
  -- Completion Engine
  -- ==========================================================================
  -- blink.cmp: Performant completion plugin with LSP, snippets, and buffer support.
  -- Uses Rust fuzzy matcher for typo resistance and performance.
  -- Keymaps: C-y (accept), C-n/C-p (navigate), C-e (close)
  {
    "saghen/blink.cmp",
    -- renovate: datasource=github-tags depName=saghen/blink.cmp
    commit = "0aa180e6eb3415f90a4f1b86801db9cab0c0ca7b", -- v1.8.0
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- renovate: datasource=git-refs depName=rafamadriz/friendly-snippets
      { "rafamadriz/friendly-snippets", commit = "6cd7280adead7f586db6fccbd15d2cac7e2188b9" },
    },
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = {}, -- Disable (conflicts with macOS IME toggle)
        ["<C-n>"] = { "show", "select_next", "fallback" },
        ["<C-p>"] = { "show", "select_prev", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      signature = { enabled = true },
    },
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
  -- Terminal
  -- ==========================================================================
  -- toggleterm.nvim: Toggle terminal with different directions
  -- <leader>th: horizontal, <leader>tv: vertical, <leader>tf: float
  {
    "akinsho/toggleterm.nvim",
    -- renovate: datasource=github-tags depName=akinsho/toggleterm.nvim
    commit = "50ea089fc548917cc3cc16b46a8211833b9e3c7c", -- v2.13.1
    keys = {
      { "<C-\\>", desc = "Toggle terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal (horizontal)" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Terminal (vertical)" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal (float)" },
    },
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        direction = "vertical",
        size = function(term)
          if term.direction == "horizontal" then
            return vim.o.lines * 0.3
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        float_opts = {
          border = "curved",
        },
      })

      -- Terminal mode: <Esc> to return to normal mode
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = function()
          vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = 0 })
        end,
      })
    end,
  },

  -- ==========================================================================
  -- Fuzzy Finder
  -- ==========================================================================
  {
    "ibhagwan/fzf-lua",
    -- renovate: datasource=git-refs depName=ibhagwan/fzf-lua
    commit = "94e2ae01cbc76ba4aa61e2c7b38fe7f25159fc29",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    keys = {
      { "<C-p>", function() require("fzf-lua").files() end, desc = "Find files" },
      { "<C-g>", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
    },
    config = function()
      require("fzf-lua").setup({ "default" })
    end,
  },

  -- ==========================================================================
  -- Git Diff Visualization
  -- ==========================================================================
  -- mini.diff: Visualize diff hunks (read-only mode)
  -- Shows git changes in the sign column (add: +, change: ~, delete: -)
  -- Mappings: [h/]h (navigate hunks), [H/]H (first/last hunk)
  {
    "nvim-mini/mini.diff",
    -- renovate: datasource=github-tags depName=nvim-mini/mini.diff
    commit = "fbb93ea1728e7c9d0944df8bd022a68402bd2e7e", -- v0.17.0
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mini.diff").setup({
        view = {
          style = "sign",
          signs = { add = "+", change = "~", delete = "-" },
        },
        mappings = {
          apply = "",
          reset = "",
          textobject = "",
          -- Navigation only
          goto_first = "[H",
          goto_prev = "[h",
          goto_next = "]h",
          goto_last = "]H",
        },
      })
    end,
  },

  -- ==========================================================================
  -- Statusline
  -- ==========================================================================
  -- mini.statusline: Minimal and fast statusline
  -- Shows: mode, git branch, diff stats, diagnostics, filename, filetype, location
  {
    "nvim-mini/mini.statusline",
    -- renovate: datasource=git-refs depName=nvim-mini/mini.statusline
    commit = "3e96596ebe51b899874d8174409cdc4f3c749d9a",
    lazy = false,
    config = function()
      require("mini.statusline").setup({
        use_icons = true,
      })
    end,
  },

  -- ==========================================================================
  -- Auto Pairs
  -- ==========================================================================
  -- mini.pairs: Automatic pairing of brackets, quotes, etc.
  -- Automatically inserts closing pair: () [] {} "" '' ``
  {
    "nvim-mini/mini.pairs",
    -- renovate: datasource=github-tags depName=nvim-mini/mini.pairs
    commit = "d5a29b6254dad07757832db505ea5aeab9aad43a", -- v0.17.0
    event = "InsertEnter",
    config = function()
      require("mini.pairs").setup()
    end,
  },

  -- ==========================================================================
  -- Trailing Whitespace
  -- ==========================================================================
  -- mini.trailspace: Highlight and remove trailing whitespace
  -- Automatically highlights trailing spaces in Normal mode
  -- <leader>tw: Trim trailing whitespace
  {
    "nvim-mini/mini.trailspace",
    -- renovate: datasource=github-tags depName=nvim-mini/mini.trailspace
    commit = "f8083ca969e1b2098480c10f3c3c4d2ce3586680", -- v0.17.0
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>tw", function() require("mini.trailspace").trim() end, desc = "Trim trailing whitespace" },
    },
    config = function()
      require("mini.trailspace").setup()
    end,
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
      -- renovate: datasource=git-refs depName=b0o/SchemaStore.nvim
      { "b0o/SchemaStore.nvim", commit = "9afa445602e6191917b4d32f1355e77b4525f905" },
      { "saghen/blink.cmp" },
    },
    config = function()
      -- -----------------------------------------------------------------------
      -- LSP Capabilities (blink.cmp)
      -- -----------------------------------------------------------------------
      -- Apply blink.cmp capabilities to all LSP servers.
      -- This enables enhanced completion features like snippets.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

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
          "lua_ls",        -- Lua language server (for Neovim config and Lua projects)
          "gopls",         -- Go language server (official Google implementation)
          "ts_ls",         -- TypeScript/JavaScript language server
          "eslint",        -- ESLint language server (JavaScript/TypeScript linting)
          "yamlls",        -- YAML language server (schema validation, completion)
          "jsonls",        -- JSON language server (schema validation, completion)
          "bashls",        -- Bash language server (shellcheck integration)
          "tailwindcss",   -- Tailwind CSS language server (class name completion)
          "gh_actions_ls", -- GitHub Actions language server (expression completion)
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
      -- JSON Language Server Configuration
      -- -----------------------------------------------------------------------
      -- Configure jsonls with SchemaStore for package.json, tsconfig.json, etc.
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- -----------------------------------------------------------------------
      -- YAML Language Server Configuration
      -- -----------------------------------------------------------------------
      -- Configure yamlls with SchemaStore for GitHub Actions, docker-compose, etc.
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
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

          -- Navigation (using fzf-lua for multi-result handling)
          -- gd: Jump to where the symbol under cursor is defined (implementation)
          -- gD: Jump to where the symbol is declared (e.g., header file in C/C++)
          --     Note: In many languages, declaration and definition are the same
          -- gi: Jump to the implementation of an interface or abstract method
          -- gr: Show all references to the symbol under cursor
          -- K:  Show hover documentation for the symbol under cursor
          -- fzf-lua defaults to jump1=true (single result jumps directly)
          -- gr uses jump1=false to always show the picker for references
          local fzf = require("fzf-lua")
          vim.keymap.set("n", "gd", function() fzf.lsp_definitions() end, opts)
          vim.keymap.set("n", "gD", function() fzf.lsp_declarations() end, opts)
          vim.keymap.set("n", "gi", function() fzf.lsp_implementations() end, opts)
          vim.keymap.set("n", "gr", function() fzf.lsp_references({ jump1 = false }) end, opts)
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
