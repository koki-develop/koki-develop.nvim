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
-- Initialize lazy.nvim with plugin specifications from lua/plugins/*.lua
-- All files in lua/plugins/ are automatically loaded and merged.

local lazy = require("lazy")

lazy.setup({
	spec = {
		{ import = "plugins" },
	},
})

-- =============================================================================
-- Auto Sync Plugins
-- =============================================================================
-- Automatically sync plugins on startup to ensure they match the commit SHAs
-- specified in plugin files. This is useful when Renovate updates the commit SHAs.

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		lazy.sync({ wait = false, show = false })
	end,
})
