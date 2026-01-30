-- =============================================================================
-- UI Plugins
-- =============================================================================
-- Plugins for visual appearance: colorscheme, bufferline, statusline, icons.

return {
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
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night", -- "night", "storm", "day", or "moon"
				terminal_colors = true,
			})
			vim.cmd.colorscheme("tokyonight")
		end,
	},

	-- ==========================================================================
	-- Bufferline
	-- ==========================================================================
	-- Display open buffers as tabs at the top of the editor.
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
		opts = {
			options = {
				separator_style = "thin", -- Thin separator for a cleaner look
				show_buffer_close_icons = false, -- Hide close icons on tabs
				show_close_icon = false, -- Hide close icon for entire bufferline
				show_buffer_icons = true, -- Show filetype icons
				diagnostics = "nvim_lsp", -- Show LSP diagnostics indicator
			},
		},
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
		opts = {
			use_icons = true,
		},
	},
}
