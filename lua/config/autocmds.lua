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
