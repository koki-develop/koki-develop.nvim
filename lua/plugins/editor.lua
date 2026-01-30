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
					require("fzf-lua").files()
				end,
				desc = "Find files",
			},
			{
				"<C-g>",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "Live grep",
			},
		},
		opts = { "default" },
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
