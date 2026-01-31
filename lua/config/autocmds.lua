-- =============================================================================
-- Autocommands
-- =============================================================================

-- -----------------------------------------------------------------------------
-- File Change Detection
-- -----------------------------------------------------------------------------
-- Automatically reload files when changed externally.
-- Combined with autoread option to detect changes without relying on focus events.

vim.api.nvim_create_autocmd({ "CursorHold", "BufEnter" }, {
	command = "checktime",
})

-- -----------------------------------------------------------------------------
-- Yank Highlight
-- -----------------------------------------------------------------------------
-- Briefly highlight yanked text to provide visual feedback.
-- Uses a custom highlight slightly more visible than Visual.

vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#3b4261" })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank({ higroup = "YankHighlight", timeout = 100 })
	end,
})
