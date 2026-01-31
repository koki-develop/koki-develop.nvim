-- =============================================================================
-- Editor Plugins
-- =============================================================================
-- Plugins for file navigation, terminal, and git diff visualization.

return {
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
			{ "nvim-lua/plenary.nvim" },
			-- LSP file operations: auto-update imports on file rename/move
			{
				"antosha417/nvim-lsp-file-operations",
				-- renovate: datasource=git-refs depName=antosha417/nvim-lsp-file-operations
				commit = "b9c795d3973e8eec22706af14959bc60c579e771",
				opts = {},
			},
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
		-- nvim-tree Options
		-- -------------------------------------------------------------------------
		opts = {
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

			-- ---------------------------------------------------------------------
			-- Focus Current File
			-- ---------------------------------------------------------------------
			-- Automatically focus the current buffer's file when opening the tree.
			update_focused_file = {
				enable = true,
			},

			-- Other options use sensible defaults:
			-- - renderer.icons.show: file/folder/git icons enabled by default
			-- - sort.sorter: "name" (alphabetical) by default
			-- - git integration: enabled by default
		},
	},

	-- ==========================================================================
	-- Fuzzy Finder
	-- ==========================================================================
	{
		"ibhagwan/fzf-lua",
		-- renovate: datasource=git-refs depName=ibhagwan/fzf-lua
		commit = "c9e07380df2826c63a8ae396559872b2553c22bc",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
		},
		keys = {
			{
				"<C-p>",
				function()
					require("fzf-lua").files({ resume = true })
				end,
				desc = "Find files (resume)",
			},
			{
				"<C-g>",
				function()
					require("fzf-lua").live_grep({ resume = true })
				end,
				desc = "Live grep (resume)",
			},
		},
		opts = {
			"default",
			grep = {
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden",
			},
		},
	},

	-- ==========================================================================
	-- Terminal
	-- ==========================================================================
	-- snacks.nvim terminal: Toggle floating terminal with <C-\>
	{
		"folke/snacks.nvim",
		-- renovate: datasource=github-tags depName=folke/snacks.nvim
		commit = "a4e46becca45eb65c73a388634b1ce8aad629ae0", -- v2.30.0
		keys = {
			{
				"<C-\\>",
				function()
					require("snacks").terminal.toggle()
				end,
				mode = { "n", "t" },
				desc = "Toggle terminal",
			},
		},
		opts = {
			terminal = {
				win = {
					position = "float",
					border = "rounded",
				},
			},
		},
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
		opts = {
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
		},
	},
}
