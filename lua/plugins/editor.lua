-- =============================================================================
-- Editor Plugins
-- =============================================================================
-- Plugins for file navigation, terminal, and git diff visualization.

return {
	-- ==========================================================================
	-- File Explorer, Fuzzy Finder & Terminal (snacks.nvim)
	-- ==========================================================================
	-- snacks.nvim: File explorer, fuzzy finder, terminal
	-- Explorer: Toggle with <leader>e
	-- Navigation: l/<CR> to open, h to close dir, <BS> to go up
	-- Operations: a (add), d (delete), r (rename), y (yank), p (paste)
	-- Picker: <C-p> files, <C-g> grep
	-- Terminal: Toggle floating terminal with <C-\>
	{
		"folke/snacks.nvim",
		-- renovate: datasource=github-tags depName=folke/snacks.nvim
		commit = "a4e46becca45eb65c73a388634b1ce8aad629ae0", -- v2.30.0
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
		},
		keys = {
			{
				"<leader>e",
				function()
					require("snacks").explorer()
				end,
				desc = "Toggle file explorer",
			},
			{
				"<C-p>",
				function()
					local picker = require("snacks").picker
					if not picker.resume({ source = "files" }) then
						picker.files()
					end
				end,
				desc = "Find files (resume)",
			},
			{
				"<C-g>",
				function()
					local picker = require("snacks").picker
					if not picker.resume({ source = "grep" }) then
						picker.grep()
					end
				end,
				desc = "Live grep (resume)",
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
			indent = {},
			picker = {
				enabled = true,
				sources = {
					files = { hidden = true }, -- include dotfiles
					grep = { hidden = true }, -- include dotfiles
					explorer = { hidden = true }, -- include dotfiles
				},
			},
			rename = { enabled = true },
			terminal = {
				win = {
					position = "float",
					border = "rounded",
				},
			},
		},
		config = function(_, opts)
			require("snacks").setup(opts)
			-- Display hidden files with normal style (not dimmed)
			vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "SnacksPickerPath" })
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
