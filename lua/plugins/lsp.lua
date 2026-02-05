-- =============================================================================
-- LSP Support
-- =============================================================================
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

return {
	"neovim/nvim-lspconfig",
	-- renovate: datasource=github-tags depName=neovim/nvim-lspconfig
	commit = "5bfcc89fd155b4ffc02d18ab3b7d19c2d4e246a7", -- v2.5.0
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- renovate: datasource=github-tags depName=mason-org/mason.nvim
		{ "mason-org/mason.nvim", commit = "44d1e90e1f66e077268191e3ee9d2ac97cc18e65" }, -- v2.2.1
		-- renovate: datasource=github-tags depName=mason-org/mason-lspconfig.nvim
		{ "mason-org/mason-lspconfig.nvim", commit = "f2fa60409630ec2d24acf84494fb55e1d28d593c" }, -- v2.1.0
		-- renovate: datasource=git-refs depName=WhoIsSethDaniel/mason-tool-installer.nvim
		{ "WhoIsSethDaniel/mason-tool-installer.nvim", commit = "443f1ef8b5e6bf47045cb2217b6f748a223cf7dc" },
		-- renovate: datasource=git-refs depName=b0o/SchemaStore.nvim
		{ "b0o/SchemaStore.nvim", commit = "9afa445602e6191917b4d32f1355e77b4525f905" },
		{ "saghen/blink.cmp" },
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
		-- Initialize mason.nvim with default settings.
		-- This must be called before mason-lspconfig setup.
		require("mason").setup()

		-- -----------------------------------------------------------------------
		-- Mason Tool Installer Setup
		-- -----------------------------------------------------------------------
		-- Automatically install formatters and other tools.
		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua", -- Lua formatter
				"shfmt", -- Shell formatter
				"goimports", -- Go imports organizer
				"prettier", -- JS/TS/JSON/YAML formatter
				"biome", -- JS/TS/JSON formatter (fast)
			},
		})

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
				"gopls", -- Go language server (official Google implementation)
				"rust_analyzer", -- Rust language server (official implementation)
				"ts_ls", -- TypeScript/JavaScript language server
				"eslint", -- ESLint language server (JavaScript/TypeScript linting)
				"yamlls", -- YAML language server (schema validation, completion)
				"jsonls", -- JSON language server (schema validation, completion)
				"bashls", -- Bash language server (shellcheck integration)
				"tailwindcss", -- Tailwind CSS language server (class name completion)
				"gh_actions_ls", -- GitHub Actions language server (expression completion)
				"terraformls", -- Terraform language server (HCL syntax, completion, diagnostics)
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
