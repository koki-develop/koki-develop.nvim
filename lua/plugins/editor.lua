-- =============================================================================
-- Editor Plugins
-- =============================================================================
-- Plugins for file navigation, terminal, and git diff visualization.

return {
	-- ==========================================================================
	-- File Explorer & Terminal (snacks.nvim)
	-- ==========================================================================
	-- snacks.nvim: File explorer and terminal
	-- Explorer: Toggle with <leader>e
	-- Navigation: l/<CR> to open, h to close dir, <BS> to go up
	-- Operations: a (add), d (delete), r (rename), y (yank), p (paste)
	-- Terminal: Toggle floating terminal with <C-\>
	{
		"folke/snacks.nvim",
		-- renovate: datasource=github-tags depName=folke/snacks.nvim
		commit = "a4e46becca45eb65c73a388634b1ce8aad629ae0", -- v2.30.0
		keys = {
			{
				"<leader>e",
				function()
					require("snacks").explorer()
				end,
				desc = "Toggle file explorer",
			},
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
			explorer = { replace_netrw = true },
			picker = { enabled = true },
			rename = { enabled = true },
			terminal = {
				win = {
					position = "float",
					border = "rounded",
				},
			},
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
