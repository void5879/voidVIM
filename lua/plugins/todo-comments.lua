--[[
================================================================================
                        TODO-COMMENTS CONFIGURATION
================================================================================

This plugin highlights and provides shortcuts for navigating "todo" comments
(like TODO, FIXME, HACK) in your codebase.

WHAT TODO-COMMENTS DOES:
- Highlights special keywords (TODO, FIXME, etc.) in bright, visible colors.
- Adds icons to the keywords for easy spotting.
- Provides keymaps to quickly jump to the next/previous todo comment.
- Can display all todos in a project using Telescope.

LOADING STRATEGY:
- Loads lazily on file open events for a faster startup.
- Depends on `plenary.nvim` for utility functions.
================================================================================
--]]

return {
	-- Quickly find and jump through todo tags
	"folke/todo-comments.nvim",

	-- ═══════════════════════════════════════════════════════════════════════
	--                              LOADING STRATEGY
	-- ═══════════════════════════════════════════════════════════════════

	event = { "BufReadPre", "BufNewFile" },

	-- ═══════════════════════════════════════════════════════════════════
	--                              DEPENDENCIES
	-- ═══════════════════════════════════════════════════════════════════

	dependencies = { "nvim-lua/plenary.nvim" },

	-- ═══════════════════════════════════════════════════════════════════════
	--                              MAIN CONFIGURATION
	-- ═══════════════════════════════════════════════════════════════════

	config = function()
		local todo_comments = require("todo-comments")

		-- Configure todo-comments with custom keywords
		todo_comments.setup({
			-- ═════════════════════════════════════════════════════════════
			--                      CUSTOM KEYWORDS
			-- ═════════════════════════════════════════════════════════════
			-- Define the keywords, icons, colors, and aliases
			keywords = {
				FIX = {
					icon = " ", -- Bug icon
					color = "error", -- Use 'error' highlight group
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- Aliases
				},
				TODO = {
					icon = " ", -- Checkmark icon
					color = "info",
					alt = { "Personal" }, -- Alias "Personal"
				},
				HACK = {
					icon = " ", -- Skull icon
					color = "warning",
					alt = { "DON SKIP" },
				},
				WARN = {
					icon = " ", -- Warning icon
					color = "warning",
					alt = { "WARNING", "XXX" },
				},
				PERF = {
					icon = " ", -- Clock icon
					color = "warning", -- Uses default color if not specified
					alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
				},
				NOTE = {
					icon = " ", -- Note icon
					color = "hint",
					alt = { "INFO", "READ", "COLORS", "Custom" },
				},
				TEST = {
					icon = "⏲ ", -- Timer icon
					color = "test", -- Custom highlight group
					alt = { "TESTING", "PASSED", "FAILED" },
				},
				FORGETNOT = {
					icon = " ", -- Warning icon
					color = "hint",
				},
			},
		})

		-- ═════════════════════════════════════════════════════════════════
		--                            KEYMAPS
		-- ═════════════════════════════════════════════════════════════════

		-- Jump to the *next* todo comment in the current buffer
		vim.keymap.set("n", "]t", function()
			todo_comments.jump_next()
		end, { desc = "TODO: Jump to Next" })

		-- Jump to the *previous* todo comment in the current buffer
		vim.keymap.set("n", "[t", function()
			todo_comments.jump_prev()
		end, { desc = "TODO: Jump to Previous" })
	end,
}

--[[
================================================================================
                              KEYMAPS REFERENCE
================================================================================

┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ ]t              │ Jump to the **next** todo comment in the current buffer  │
│ [t              │ Jump to the **previous** todo comment in the buffer      │
└─────────────────┴──────────────────────────────────────────────────────────┘

================================================================================
                              BEHAVIOR GUIDE
================================================================================

1. HOW TO USE:
   - In any code file, add a comment like:
     `-- TODO: Remember to refactor this`
     `// FIXME: This is broken!`
     `# HACK: A temporary fix`

2. WHAT YOU WILL SEE:
   - The plugin will automatically highlight `TODO:`, `FIXME:`, etc.
   - It will use the icons and colors you defined (e.g., ` FIXME:` in red).

3. NAVIGATION:
   - Press `]t` to jump forward to the next `TODO`, `FIX`, `WARN`, etc.
   - Press `[t` to jump backward.

4. SEARCHING (with Telescope):
   - If you have `telescope.nvim` installed, you can load the `todo-comments`
     extension.
   - Run `:Telescope todo-comments` to see a list of all `TODO`s across
     your entire project.

================================================================================
--]]
