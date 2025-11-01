--[[
================================================================================
                        NVIM-UFO FOLDING CONFIGURATION
================================================================================

Nvim-ufo provides advanced, high-performance code folding capabilities for
Neovim. It replaces the standard folding system with one that can be powered
by Treesitter, indentation, or LSP, offering faster and more accurate folds.

WHAT UFO DOES:
- Provides extremely fast and responsive code folding.
- Uses Treesitter parsers to create "smart" folds based on code structure.
- Can fall back to indentation-based folding for unsupported file types.
- Integrates well with the Neovim's built-in folding commands.

LOADING STRATEGY:
- Loads lazily on file open events for a faster startup.
- Depends on `promise-async` for its asynchronous operations.

PERFORMANCE BENEFITS:
- Significantly faster than native `foldmethod=treesitter`.
- Folds are computed asynchronously, so it doesn't block the UI.
================================================================================
--]]

return {
	-- High-performance folding plugin
	{
		"kevinhwang91/nvim-ufo",

		-- ═══════════════════════════════════════════════════════════════════
		--                              LOADING STRATEGY
		-- ═══════════════════════════════════════════════════════════════════

		-- Load lazily when a file is opened
		event = { "BufReadPost", "BufNewFile" },

		-- ═══════════════════════════════════════════════════════════════════
		--                              DEPENDENCIES
		-- ═══════════════════════════════════════════════════════════════════

		dependencies = {
			-- Required for async operations in nvim-ufo
			"kevinhwang91/promise-async",
		},

		-- ═══════════════════════════════════════════════════════════════════
		--                              MAIN CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════

		config = function()
			-- Import the ufo plugin
			local ufo = require("ufo")

			-- Configure ufo with our preferences
			ufo.setup({
				-- ═════════════════════════════════════════════════════════
				--                       FOLD PROVIDER
				-- ═════════════════════════════════════════════════════════

				-- This function selects which folding provider to use
				-- It's configured to first try "treesitter" for smart folding
				-- If treesitter is not available for the language, it falls
				-- back to "indent" based folding.
				provider_selector = function(_, _, _)
					return { "treesitter", "indent" }
				end,

				-- ═════════════════════════════════════════════════════════
				--                        UI SETTINGS
				-- ═════════════════════════════════════════════════════════

				-- Disable the brief highlight that appears after opening a fold
				-- Set to a number (e.g., 150) if you want the highlight
				open_fold_hl_timeout = 0,
			})

			-- ═════════════════════════════════════════════════════════════
			--                      VIM FOLDING OPTIONS
			-- ═════════════════════════════════════════════════════════════

			-- Enable folding globally
			vim.o.foldenable = true

			-- Set the fold column to '0'
			-- This hides the fold indicator column on the far left,
			-- saving screen space. Folds are still indicated in the signcolumn
			-- or by the folded text itself.
			vim.o.foldcolumn = "0"

			-- Set fold levels to 99 (start fully expanded)
			-- UFO providers work best when this is set to a high number,
			-- ensuring that all potential folds are created by the provider.
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99

			-- ═════════════════════════════════════════════════════════════
			--                            KEYMAPS
			-- ═════════════════════════════════════════════════════════════

			-- Open all folds in the buffer
			vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "UFO: Open all folds" })

			-- Close all folds in the buffer
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "UFO: Close all folds" })

			-- Note: 'za' to toggle a fold at the cursor is a built-in Vim keymap
			-- and will work perfectly with nvim-ufo.
		end,
	},
}

--[[
================================================================================
                              KEYMAPS REFERENCE
================================================================================

┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ zR              │ Open all folds in the current buffer                     │
│ zM              │ Close all folds in the current buffer                    │
│ za              │ (Built-in) Toggle the fold under the cursor              │
│ zc              │ (Built-in) Close the fold under the cursor               │
│ zo              │ (Built-in) Open the fold under the cursor                │
└─────────────────┴──────────────────────────────────────────────────────────┘

================================================================================
                              BEHAVIOR GUIDE
================================================================================

1. HOW FOLDING WORKS:
   - When you open a file, `nvim-ufo` will (in the background) ask Treesitter
     to identify all the code blocks (functions, classes, etc.).
   - If Treesitter isn't available for that filetype, `ufo` will use the
     indentation levels to determine fold blocks.
   - All folds will be open by default (`foldlevel = 99`).

2. YOUR WORKFLOW:
   - Use `zM` to quickly collapse the entire file to see an overview.
   - Use `zR` to expand everything again.
   - Use `za` on a line with a fold to toggle it open or closed.

3. PROVIDER_SELECTOR:
   - `{"treesitter", "indent"}` is the key. It means "Try to be smart (Treesitter),
     but if you can't, just use indentation (indent)." This gives you the
     best of both worlds: smart folding where available, and basic
     folding everywhere else.

================================================================================
--]]
