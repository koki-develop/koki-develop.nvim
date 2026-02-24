-- =============================================================================
-- Coding Plugins
-- =============================================================================
-- Plugins for code editing: completion, AI, auto-pairs, formatting.

return {
	-- ==========================================================================
	-- Completion Engine
	-- ==========================================================================
	-- blink.cmp: Performant completion plugin with LSP, snippets, and buffer support.
	-- Uses Rust fuzzy matcher for typo resistance and performance.
	-- Keymaps: C-y (accept), C-n/C-p (navigate), C-e (close)
	{
		"saghen/blink.cmp",
		-- renovate: datasource=github-tags depName=saghen/blink.cmp
		commit = "b19413d214068f316c78978b08264ed1c41830ec", -- v1.8.0
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
	-- Surround
	-- ==========================================================================
	-- mini.surround: Add, delete, replace surrounding pairs (vim-surround style).
	-- ys{motion}{char}: Add surrounding (e.g., ysiw) to add around inner word)
	-- ds{char}: Delete surrounding (e.g., ds")
	-- cs{from}{to}: Change surrounding (e.g., cs"')
	{
		"nvim-mini/mini.surround",
		-- renovate: datasource=github-tags depName=nvim-mini/mini.surround
		commit = "88c52297ed3e69ecf9f8652837888ecc727a28ee", -- v0.17.0
		config = function()
			require("mini.surround").setup({
				-- vim-surround style mappings
				mappings = {
					add = "ys",
					delete = "ds",
					replace = "cs",
					find = "",
					find_left = "",
					highlight = "",
					update_n_lines = "",
				},
			})
			-- Remap visual mode surround from `ys` to `S` to avoid conflict with `y` (yank)
			vim.keymap.del("x", "ys")
			vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = "Add surrounding" })
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
		opts = {},
	},

	-- ==========================================================================
	-- Auto Tag
	-- ==========================================================================
	-- nvim-ts-autotag: Treesitter-based auto close and auto rename of HTML/JSX tags.
	-- Automatically closes tags: <div> → <div></div>
	-- Automatically renames paired tags when editing one side.
	{
		"windwp/nvim-ts-autotag",
		-- renovate: datasource=git-refs depName=windwp/nvim-ts-autotag
		commit = "8e1c0a389f20bf7f5b0dd0e00306c1247bda2595",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
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
			{
				"<leader>tw",
				function()
					require("mini.trailspace").trim()
				end,
				desc = "Trim trailing whitespace",
			},
		},
		opts = {},
	},

	-- ==========================================================================
	-- Code Formatter
	-- ==========================================================================
	-- conform.nvim: Lightweight yet powerful formatter plugin.
	-- Supports multiple formatters per filetype with LSP fallback.
	-- <leader>f: Format buffer, format_on_save: enabled
	{
		"stevearc/conform.nvim",
		-- renovate: datasource=github-tags depName=stevearc/conform.nvim
		commit = "3543d000dafbc41cc7761d860cfdb24e82154f75", -- v9.1.0
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				desc = "Format buffer",
			},
		},
		opts = function()
			local util = require("conform.util")

			-- Use oxfmt if config exists, biome if config exists, otherwise prettier
			local function js_formatter()
				if vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc.jsonc" }, { upward = true })[1] then
					return { "oxfmt" }
				end
				if vim.fs.find({ "biome.json", "biome.jsonc" }, { upward = true })[1] then
					return { "biome" }
				end
				return { "prettier" }
			end

			return {
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "goimports", "gofmt" },
					javascript = js_formatter,
					typescript = js_formatter,
					javascriptreact = js_formatter,
					typescriptreact = js_formatter,
					json = js_formatter,
					yaml = { "prettier" },
					sh = { "shfmt" },
				},
				default_format_opts = {
					lsp_format = "fallback",
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
				formatters = {
					oxfmt = {
						command = util.from_node_modules("oxfmt"),
						args = { "--stdin-filepath", "$FILENAME" },
						stdin = true,
						cwd = util.root_file({ ".oxfmtrc.json", ".oxfmtrc.jsonc" }),
					},
				},
			}
		end,
	},

	-- ==========================================================================
	-- TODO Comments
	-- ==========================================================================
	-- todo-comments.nvim: Highlight and search TODO, FIXME, BUG, etc. in comments.
	-- Supports quickfix list, Telescope, and jump navigation.
	-- ]t / [t: Jump to next/prev TODO comment
	{
		"folke/todo-comments.nvim",
		-- renovate: datasource=github-tags depName=folke/todo-comments.nvim
		commit = "31e3c38ce9b29781e4422fc0322eb0a21f4e8668", -- v1.5.0
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next TODO",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Prev TODO",
			},
		},
		opts = {},
	},
}
