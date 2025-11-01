--[[
================================================================================
                        GITSIGNS (GIT GUTTER) CONFIGURATION
================================================================================

This file configures `gitsigns.nvim`, a plugin that shows Git change markers
in the "gutter" (the sign column on the left).

WHAT GITSIGNS DOES:
- Shows icons for added, modified, and deleted lines.
- Provides "hunks" (blocks of changes) that you can navigate between.
- Allows you to stage, reset, or preview hunks directly from the editor.
- Integrates with Neovim's diff features and provides text objects.

LOADING STRATEGY:
- Loads lazily when a file is opened.
- The configuration is done via `opts` which passes settings to the
  plugin's `setup` function.
- Keymaps are set in the `on_attach` function, so they are buffer-local
  and only active in buffers where Gitsigns is running.
================================================================================
--]]

return {
	{
		-- The Git gutter integration plugin
		"lewis6991/gitsigns.nvim",

		-- ═══════════════════════════════════════════════════════════════════
		--                              LOADING STRATEGY
		-- ═══════════════════════════════════════════════════════════════════

		event = { "BufReadPre", "BufNewFile" },

		-- ═══════════════════════════════════════════════════════════════════
		--                              MAIN CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════

		opts = {
			-- `on_attach` is the recommended way to set keymaps for Gitsigns
			-- It ensures keymaps are buffer-local and only set when gitsigns is active
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				-- Helper function to simplify keymap creation
				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- ═════════════════════════════════════════════════════════
				--                       HUNK NAVIGATION
				-- ═════════════════════════════════════════════════════════
				-- Jump between blocks of changes (hunks)
				map("n", "]h", gs.next_hunk, "Git: Next Hunk")
				map("n", "[h", gs.prev_hunk, "Git: Prev Hunk")

				-- ═════════════════════════════════════════════════════════
				--                       HUNK ACTIONS
				-- ═════════════════════════════════════════════════════════
				-- Act on the hunk under the cursor
				map("n", "<leader>gs", gs.stage_hunk, "Git: Stage Hunk")
				map("n", "<leader>gr", gs.reset_hunk, "Git: Reset Hunk")

				-- Act on a visual selection
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Git: Stage Selected Hunk")
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Git: Reset Selected Hunk")

				-- ═════════════════════════════════════════════════════════
				--                       BUFFER ACTIONS
				-- ═════════════════════════════════════════════════════════
				map("n", "<leader>gS", gs.stage_buffer, "Git: Stage Buffer")
				map("n", "<leader>gR", gs.reset_buffer, "Git: Reset Buffer")
				map("n", "<leader>gu", gs.undo_stage_hunk, "Git: Undo Stage Hunk")

				-- ═════════════════════════════════════════════════════════
				--                       ADVANCED ACTIONS
				-- ═════════════════════════════════════════════════════════
				map("n", "<leader>gp", gs.preview_hunk, "Git: Preview Hunk")
				map("n", "<leader>gbl", function()
					gs.blame_line({ full = true })
				end, "Git: Blame Line (Full)")
				map("n", "<leader>gB", gs.toggle_current_line_blame, "Git: Toggle Line Blame")
				map("n", "<leader>gd", gs.diffthis, "Git: Diff This")
				map("n", "<leader>gD", function()
					gs.diffthis("~")
				end, "Git: Diff This ~ (Cached)")

				-- ═════════════════════════════════════════════════════════
				--                       TEXT OBJECT
				-- ═════════════════════════════════════════════════════════
				-- Provides `ih` text object (e.g., `dih` = delete inner hunk)
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Git: Select 'inner hunk'")
			end,
		},
	},
}

--[[
================================================================================
                              KEYMAPS REFERENCE
================================================================================

NAVIGATION:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ ]h              │ Jump to the **next** Git hunk (block of changes)         │
│ [h              │ Jump to the **previous** Git hunk                        │
└─────────────────┴──────────────────────────────────────────────────────────┘

ACTIONS (HUNK):
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <leader>gs      │ (Normal) Stage the hunk under the cursor                 │
│                 │ (Visual) Stage the selected lines                        │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <leader>gr      │ (Normal) Reset (revert) the hunk under the cursor        │
│                 │ (Visual) Reset the selected lines                        │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <leader>gu      │ Undo the last `stage_hunk` action                        │
│ <leader>gp      │ Show a preview of the hunk in a floating window          │
└─────────────────┴──────────────────────────────────────────────────────────┘

ACTIONS (BUFFER):
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <leader>gS      │ Stage all changes in the current buffer                  │
│ <leader>gR      │ Reset (revert) all changes in the current buffer         │
└─────────────────┴──────────────────────────────────────────────────────────┘

ADVANCED & BLAME:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <leader>gbl     │ Show full `git blame` info for the current line          │
│ <leader>gB      │ Toggle a "virtual text" blame on the current line        │
│ <leader>gd      │ View diff against the version in the index (staged)      │
│ <leader>gD      │ View diff against the version at HEAD (last commit)      │
└─────────────────┴──────────────────────────────────────────────────────────┘

TEXT OBJECT:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ ih              │ "Inner Hunk". Selects the current Git hunk.              │
│                 │ (e.g., `dih` deletes the hunk, `csih` changes it)        │
└─────────────────┴──────────────────────────────────────────────────────────┘

================================================================================
--]]
