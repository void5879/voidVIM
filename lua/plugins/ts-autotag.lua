--[[
================================================================================
                        NVIM-TS-AUTOTAG CONFIGURATION
================================================================================

This plugin uses Treesitter to automatically close and rename paired HTML/XML
tags, similar to the feature in VS Code.

WHAT AUTOTAG DOES:
- Auto-closing tags: Type `<div>` and it inserts `</div>`.
- Auto-renaming tags: Change `<div>` to `<span>` and it automatically changes
  the matching `</div>` to `</span>`.

LOADING STRATEGY:
- Loads only for specific web-related filetypes (`html`, `javascriptreact`, etc.).
- This keeps the plugin from loading when editing other filetypes.
================================================================================
--]]

return {
	{
		"windwp/nvim-ts-autotag",

		-- ═══════════════════════════════════════════════════════════════════
		--                              LOADING STRATEGY
		-- ═══════════════════════════════════════════════════════════════════

		-- Explicitly enable the plugin (this is often used in lazy.nvim setups)
		enabled = true,

		-- Only load this plugin for these specific filetypes
		ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },

		-- ═══════════════════════════════════════════════════════════════════
		--                              MAIN CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════

		config = function()
			-- Setup the plugin
			require("nvim-ts-autotag").setup({
				-- ═════════════════════════════════════════════════════════
				--                        GLOBAL OPTIONS
				-- ═════════════════════════════════════════════════════════
				opts = {
					-- Enable auto-closing tags (e.g., `<div>` -> `</div>`)
					enable_close = true,
					-- Enable auto-renaming paired tags
					enable_rename = true,
					-- Disable the feature where typing `</` auto-closes
					-- This is often set to `false` because nvim-autopairs
					-- might already handle this, leading to conflicts.
					enable_close_on_slash = false,
				},

				-- ═════════════════════════════════════════════════════════
				--                     FILETYPE OVERRIDES
				-- ═════════════════════════════════════════════════════════
				-- You can override settings on a per-filetype basis
				-- Note: Your current overrides are redundant as they set
				-- the defaults, but they are kept here as an example.
				per_filetype = {
					["html"] = {
						enable_close = true, -- Auto-close in HTML
					},
					["typescriptreact"] = {
						enable_close = true, -- Auto-close in TSX/React
					},
				},
			})
		end,
	},
}

--[[
================================================================================
                              BEHAVIOR GUIDE
================================================================================

AUTO-CLOSING TAGS:
1.  In an HTML, JSX, or Svelte file, type `<div`
2.  Type the closing `>`
3.  The plugin automatically inserts `</div>` after your cursor.
    * Result: `<div>|</div>` (where `|` is your cursor)

AUTO-RENAMING TAGS:
1.  You have the following code:
    `<div class="container">
       <p>Hello</p>
     </div>`
2.  Move your cursor to the opening `div` and change it to `section`.
3.  As you type, the plugin automatically changes the closing `</div>`
    to `</section>`.
    * Result:
        `<section class="container">
           <p>Hello</p>
         </section>`

================================================================================
--]]
