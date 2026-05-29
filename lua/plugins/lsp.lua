-- =============================================================================
-- LSP Support
-- =============================================================================
-- This configuration sets up Language Server Protocol (LSP) support using
-- several complementary plugins:
--
-- - mason.nvim: A portable package manager for Neovim that manages external
--   editor tooling such as LSP servers, DAP servers, linters, and formatters.
--   It provides a nice UI accessible via :Mason command.
--
-- - mason-tool-installer.nvim: Installs and auto-updates all mason packages
--   (LSPs, formatters, etc.) listed in its `ensure_installed` option.
--
-- - mason-lspconfig.nvim: Bridges mason.nvim with nvim-lspconfig, auto-enabling
--   installed LSP servers via vim.lsp.enable() (no manual setup calls needed).
--
-- - nvim-lspconfig: Provides default configurations for various LSP servers,
--   making it easy to set up language servers with sensible defaults.

return {
	"neovim/nvim-lspconfig",
	-- renovate: datasource=github-tags depName=neovim/nvim-lspconfig
	commit = "f6738ef65dabade340b473d4ff2a1ad3352c10e7", -- v2.9.0
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- renovate: datasource=github-tags depName=mason-org/mason.nvim
		{ "mason-org/mason.nvim", commit = "bb639d4bf385a4d89f478b83af4d770be05ab7eb" }, -- v2.3.0
		-- renovate: datasource=github-tags depName=mason-org/mason-lspconfig.nvim
		{ "mason-org/mason-lspconfig.nvim", commit = "0c2823e0418f3d9230ff8b201c976e84de1cb401" }, -- v2.2.0
		-- renovate: datasource=git-refs depName=WhoIsSethDaniel/mason-tool-installer.nvim
		{ "WhoIsSethDaniel/mason-tool-installer.nvim", commit = "443f1ef8b5e6bf47045cb2217b6f748a223cf7dc" },
		-- renovate: datasource=git-refs depName=b0o/SchemaStore.nvim
		{ "b0o/SchemaStore.nvim", commit = "efa62017f59a6346486cc567d70acce965a00b12" },
		{ "saghen/blink.cmp" },
		-- renovate: datasource=github-tags depName=j-hui/fidget.nvim
		{ "j-hui/fidget.nvim", commit = "b61e8af9b8b68ee0ec7da5fb7a8c203aae854f2e", opts = {} }, -- v1.6.1
	},
	config = function()
		-- -----------------------------------------------------------------------
		-- LSP Capabilities (blink.cmp)
		-- -----------------------------------------------------------------------
		-- Apply capabilities to all LSP servers:
		-- - blink.cmp: Enhanced completion features like snippets
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})

		-- -----------------------------------------------------------------------
		-- Mason Setup
		-- -----------------------------------------------------------------------
		-- Pin the mason-registry to a specific tag so that package versions are
		-- managed by Renovate (see renovate.json). This must be called before
		-- mason-lspconfig setup.
		require("mason").setup({
			registries = {
				-- renovate: datasource=github-tags depName=mason-org/mason-registry
				"github:mason-org/mason-registry@2026-04-21-joint-sheet",
			},
		})

		-- -----------------------------------------------------------------------
		-- Mason Tool Installer Setup
		-- -----------------------------------------------------------------------
		-- Install and auto-update all mason packages (LSPs, formatters, etc.) on
		-- startup. Package names use mason's naming convention (e.g.
		-- `lua-language-server` rather than lspconfig's `lua_ls`).
		require("mason-tool-installer").setup({
			auto_update = true,
			run_on_start = true,
			ensure_installed = {
				-- Formatters
				"stylua", -- Lua formatter
				"shfmt", -- Shell formatter
				"goimports", -- Go imports organizer
				"prettier", -- JS/TS/JSON/YAML formatter
				"biome", -- JS/TS/JSON formatter (fast)
				-- LSPs
				"lua-language-server", -- Lua (for Neovim config and Lua projects)
				"gopls", -- Go (official Google implementation)
				"rust-analyzer", -- Rust (official implementation)
				"typescript-language-server", -- TypeScript/JavaScript
				"eslint-lsp", -- ESLint (JavaScript/TypeScript linting)
				"yaml-language-server", -- YAML (schema validation, completion)
				"json-lsp", -- JSON (schema validation, completion)
				"bash-language-server", -- Bash (shellcheck integration)
				"tailwindcss-language-server", -- Tailwind CSS (class name completion)
				"gh-actions-language-server", -- GitHub Actions (expression completion)
				"terraform-ls", -- Terraform (HCL syntax, completion, diagnostics)
			},
		})

		-- -----------------------------------------------------------------------
		-- Mason-LSPConfig Setup
		-- -----------------------------------------------------------------------
		-- Enable installed LSP servers via vim.lsp.enable() on Neovim 0.11+.
		-- Installation is managed by mason-tool-installer (see above).
		require("mason-lspconfig").setup({
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
		-- Diagnostic Configuration
		-- -----------------------------------------------------------------------
		-- Configure diagnostic display. Placed here to defer loading of
		-- vim.diagnostic module until LSP is actually used.
		vim.diagnostic.config({
			virtual_text = true,
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

				-- Navigation (using snacks.nvim picker for multi-result handling)
				-- gd: Jump to where the symbol under cursor is defined (implementation)
				-- gD: Jump to where the symbol is declared (e.g., header file in C/C++)
				--     Note: In many languages, declaration and definition are the same
				-- gi: Jump to the implementation of an interface or abstract method
				-- gr: Show all references to the symbol under cursor
				-- K:  Show hover documentation for the symbol under cursor
				-- Note: Single result auto-jumps, multiple results show picker
				vim.keymap.set("n", "gd", function()
					require("snacks").picker.lsp_definitions()
				end, opts)
				vim.keymap.set("n", "gD", function()
					require("snacks").picker.lsp_declarations()
				end, opts)
				vim.keymap.set("n", "gi", function()
					require("snacks").picker.lsp_implementations()
				end, opts)
				vim.keymap.set("n", "gr", function()
					require("snacks").picker.lsp_references()
				end, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				-- Refactoring
				-- <leader>rn: Rename the symbol under cursor across all references
				-- <leader>ca: Show available code actions (quick fixes, refactorings)
				-- Note: <leader>f (format) is handled by conform.nvim
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

				-- Diagnostics
				-- [d: Jump to the previous diagnostic (error, warning, hint)
				-- ]d: Jump to the next diagnostic
				-- <leader>d: Show diagnostic details in a floating window
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1 })
				end, opts)
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1 })
				end, opts)
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
			end,
		})
	end,
}
