--[[
================================================================================
                        AUTO-SESSION CONFIGURATION
================================================================================

Auto-session automatically saves your Neovim session (open files, buffers,
window layouts) when you quit, and allows you to restore it later.
This is perfect for quickly getting back to work on a project.

WHAT AUTO-SESSION DOES:
- Saves the state of your editor (buffers, windows, cursor positions)
- Manages sessions based on the current working directory (project)
- Allows manual saving and restoring of sessions via commands
- Can be configured to automatically restore sessions (or not)

WHY USE IT:
- Stop worrying about closing Neovim and losing your open files
- Quickly jump back into a project exactly where you left off
- Manage different sessions for different projects
- This config disables auto-restore for a more manual, controlled workflow

PERFORMANCE:
- Loads lazily ("VeryLazy" event) so it doesn't impact startup time
- Session saving/loading is fast and happens on command or on exit
================================================================================
--]]

return {
	-- Automatic session saving and restoring
	"rmagatti/auto-session",

	-- ═══════════════════════════════════════════════════════════════════════
	--                              LOADING STRATEGY
	-- ═══════════════════════════════════════════════════════════════════════

	-- Load the plugin very lazily. It won't load until after startup,
	-- or when one of its commands or keymaps is triggered.
	-- This ensures it has zero impact on your Neovim startup time.
	event = "VeryLazy",

	-- ═══════════════════════════════════════════════════════════════════════
	--                              MAIN CONFIGURATION
	-- ═══════════════════════════════════════════════════════════════════════

	config = function()
		-- Import the auto-session plugin
		local auto_session = require("auto-session")

		-- Setup auto-session with configuration
		auto_session.setup({

			-- ═════════════════════════════════════════════════════════════
			--                      SESSION BEHAVIOR
			-- ═════════════════════════════════════════════════════════════

			-- Disable automatic session restoration when Neovim starts
			-- We will restore manually using a keymap (<leader>wr)
			-- Set to `true` if you want Neovim to always load the last session
			auto_restore_enabled = false,

			-- ═════════════════════════════════════════════════════════════
			--                      SUPPRESSED DIRECTORIES
			-- ═════════════════════════════════════════════════════════════

			-- Don't save sessions for these common, non-project directories
			-- This prevents "junk" sessions from being created when you're
			-- in your home directory, Downloads, etc.
			auto_session_suppress_dirs = {
				"~/",
				"~/Dev/", -- Note: You may want to remove this if ~/Dev/ contains projects
				"~/Downloads",
				"~/Documents",
				"~/Desktop/",
			},
		})

		-- ═════════════════════════════════════════════════════════════════
		--                            KEYMAPS
		-- ═════════════════════════════════════════════════════════════════

		-- Keymap for manually restoring a session
		-- <leader>wr = "Workspace Restore"
		-- Restores the last saved session for the current directory
		vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "[W]orkspace [R]estore session" })

		-- Keymap for manually saving a session
		-- <leader>ws = "Workspace Save"
		-- Saves the current buffers and window layout as a session
		vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "[W]orkspace [S]ave session" })
	end,
}

--[[
================================================================================
                              AUTO-SESSION BEHAVIOR GUIDE
================================================================================

This configuration is set up for a MANUAL workflow.

1. SAVING A SESSION:
   - Navigate to your project directory (e.g., `cd ~/Dev/my-project`)
   - Open Neovim (`nvim .`)
   - Open your files, create window splits, etc.
   - Press `<leader>ws` to manually save the session for this directory.
   - The session is now saved (usually in ~/.local/share/nvim/sessions/)

2. RESTORING A SESSION:
   - Close Neovim.
   - Later, open Neovim in that same project directory (`nvim .`)
   - Your files will NOT be open automatically (because `auto_restore_enabled = false`)
   - Press `<leader>wr` to manually restore the session.
   - Your files and window layout will be restored instantly.

================================================================================
                              CONFIGURATION EXPLAINED
================================================================================

KEY SETTINGS:
┌──────────────────────────────┬──────────────────────────────────────────────────┐
│ Setting                      │    Purpose                                       │
├──────────────────────────────┼──────────────────────────────────────────────────┤
│ event = "VeryLazy"           │ Don't load plugin until needed; zero startup cost│
│ auto_restore_enabled = false │ Disables automatic restore on startup            │
│ auto_session_suppress_dirs   │ Prevents saving sessions for non-project folders │
└──────────────────────────────┴──────────────────────────────────────────────────┘

KEYMAP REFERENCE:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Keymap          │ Action & Description                                     │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <leader>wr      │ "[W]orkspace [R]estore": Manually loads the session      │
│                 │ for the current working directory.                       │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <leader>ws      │ "[W]orkspace [S]ave": Manually saves the current state   │
│                 │ as a session for the current working directory.          │
└─────────────────┴──────────────────────────────────────────────────────────┘

--]]
