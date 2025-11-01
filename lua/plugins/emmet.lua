--[[
================================================================================
                        NVIM-EMMET CONFIGURATION
================================================================================

This file configures `nvim-emmet`, a plugin that provides a convenient way
to wrap text with Emmet abbreviations (like HTML tags).

WHAT THIS PLUGIN DOES:
- Provides a function `wrap_with_abbreviation`
- This is NOT the full Emmet-LS (Language Server) which provides
  abbreviation expansion in insert mode (e.g., `div>p` -> `<div><p></p></div>`).
- This plugin is specifically for *wrapping* existing text.

NOTE:
As your comment states, this is *only* for wrapping. The Emmet abbreviation
expansion in insert mode is typically handled by `emmet-ls` (which you
have installed via Mason) and integrated into `nvim-cmp`. This plugin
provides a capability that `emmet-ls` sometimes lacks or is clumsy at.
================================================================================
--]]

return {
	-- Provides Emmet's "wrap with abbreviation" functionality
	"olrtg/nvim-emmet",

	-- ═══════════════════════════════════════════════════════════════════════
	--                              LOADING STRATEGY
	-- ═══════════════════════════════════════════════════════════════════════

	-- No `event` or `lazy` key is specified, so this plugin will load
	-- on startup by default. This is fine as it's a very small plugin.

	-- ═══════════════════════════════════════════════════════════════════════
	--                              MAIN CONFIGURATION
	-- ═══════════════════════════════════════════════════════════════════

	config = function()
		-- ═════════════════════════════════════════════════════════════════
		--                            KEYMAP
		-- ═════════════════════════════════════════════════════════════════

		-- Set keymap for both Normal ('n') and Visual ('v') modes
		-- <leader>xe = "Emmet Expand" (or "Emmet Wrap")
		-- This keymap triggers the "wrap_with_abbreviation" command
		vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
	end,
}

--[[
================================================================================
                              EMMET WRAP BEHAVIOR GUIDE
================================================================================

This plugin provides one primary function: wrapping text.

HOW TO USE (VISUAL MODE):
1. Visually select the text you want to wrap.
   (e.g., select the words "Hello World")
2. Press `<leader>xe`.
3. A prompt will appear at the bottom of the screen.
4. Type your Emmet abbreviation (e.g., `div.container>p.greeting`)
5. Press Enter.
6. The selected text will be wrapped:
   <div class="container">
       <p class="greeting">
           Hello World
       </p>
   </div>

HOW TO USE (NORMAL MODE):
1. This keymap also works in Normal mode, but it's less common.
2. It will prompt you for an abbreviation and then for the text to wrap.
3. Using Visual mode (as described above) is the recommended workflow.

================================================================================
                              CONFIGURATION EXPLAINED
================================================================================

KEYMAP REFERENCE:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Keymap          │ Action & Description                                     │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <leader>xe      │ (In Visual Mode) Prompts for an Emmet abbreviation       │
│                 │ to wrap the selected text with.                          │
└─────────────────┴──────────────────────────────────────────────────────────┘

WHY THIS PLUGIN?
- `emmet-ls` (from Mason) is great for *expanding* abbreviations in Insert mode.
- `nvim-emmet` (this plugin) is great for *wrapping* existing text in Normal
  or Visual mode.
- The two plugins complement each other for a full Emmet workflow.

--]]
