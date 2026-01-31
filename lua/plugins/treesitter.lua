-- =============================================================================
-- Treesitter
-- =============================================================================
-- nvim-treesitter: Syntax highlighting and code parsing using tree-sitter.
-- Provides better syntax highlighting, code folding, and other features
-- based on actual code structure rather than regex patterns.

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		-- renovate: datasource=git-refs depName=nvim-treesitter/nvim-treesitter packageName=https://github.com/nvim-treesitter/nvim-treesitter branch=main
		commit = "19c729dae6e0eeb79423df0cf37780aa9a7cc3b7",
		lazy = false, -- This plugin does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					-- Core (required for treesitter development)
					"vim",
					"vimdoc",
					"query",
					-- Languages (based on LSP servers)
					"lua",
					"go",
					"gomod",
					"gosum",
					"typescript",
					"javascript",
					"tsx",
					"json",
					"yaml",
					"bash",
					"terraform",
					"hcl",
					-- Web
					"html",
					"css",
					-- Documentation
					"markdown",
					"markdown_inline",
				},
			})
		end,
	},
}
