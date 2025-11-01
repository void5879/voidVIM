--[[
================================================================================
                        TAILWIND & COLORIZER CONFIGURATION
================================================================================

This file sets up two related plugins to enhance CSS and color visualization
directly in the editor.

PLUGINS IN THIS FILE:
1. `nvim-colorizer.lua`: The main plugin. It highlights text that represents
   a color (e.g., `#FFFFFF`, `rgb(0,0,0)`, `red`) with the color itself.
   It is configured here to also understand Tailwind CSS color names.
2. `tailwindcss-colorizer-cmp.nvim`: An extension plugin that adds color
   swatches to the `nvim-cmp` completion menu when completing Tailwind classes.

WHAT THIS SETUP DOES:
- Shows the actual color for hex codes, rgb, and hsl values.
- Shows the actual color for Tailwind classes (e.g., `bg-blue-500` will be
  highlighted with that shade of blue).
- Shows color swatches in the completion menu for Tailwind classes.
================================================================================
--]]

return {
	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │           1. TAILWIND-COLORIZER-CMP (COMPLETION SWATCHES)               │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		-- This plugin adds color swatches to the nvim-cmp completion menu
		-- for Tailwind CSS utility classes.
		"roobert/tailwindcss-colorizer-cmp.nvim",

		-- Load lazily when a file is opened
		event = { "BufReadPost", "BufNewFile" },
	},

	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                   2. NVIM-COLORIZER (MAIN HIGHLIGHTER)                  │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		"NvChad/nvim-colorizer.lua",

		-- ═══════════════════════════════════════════════════════════════════
		--                              LOADING STRATEGY
		-- ═══════════════════════════════════════════════════════════════════

		event = { "BufReadPost", "BufNewFile" },

		-- ═══════════════════════════════════════════════════════════════════
		--                              DEPENDENCIES
		-- ═══════════════════════════════════════════════════════════════════

		dependencies = {
			-- Colorizer needs Treesitter to accurately find color strings
			"nvim-treesitter/nvim-treesitter",
		},

		-- `opts = {}` is a common pattern to just load with default options
		-- if no `config` function is provided, but we have a config function.
		opts = {},

		-- ═══════════════════════════════════════════════════════════════════
		--                              MAIN CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════

		config = function()
			-- Import the plugins
			local nvchadcolorizer = require("colorizer")
			local tailwindcolorizer = require("tailwindcss-colorizer-cmp")

			-- ═════════════════════════════════════════════════════════════
			--                 NVCHAD-COLORIZER SETUP
			-- ═════════════════════════════════════════════════════════════
			nvchadcolorizer.setup({
				-- Specify which filetypes to activate colorizer for
				filetypes = { "html", "css", "javascript", "typescript", "jsx", "tsx", "vue", "svelte" },

				-- Default options
				user_default_options = {
					-- CRITICAL: Enable Tailwind CSS mode
					-- This tells colorizer to parse `tailwind.config.js`
					-- and highlight Tailwind class names (e.g., `bg-red-500`)
					tailwind = true,
				},
			})

			-- ═════════════════════════════════════════════════════════════
			--               TAILWIND-COLORIZER-CMP SETUP
			-- ═════════════════════════════════════════════════════════════
			tailwindcolorizer.setup({
				-- Set the width of the color swatch in the completion menu
				color_square_width = 2,
			})

			-- ═════════════════════════════════════════════════════════════
			--                      AUTO-ATTACH COMMAND
			-- ═════════════════════════════════════════════════════════════

			-- Create an autocommand to automatically attach the colorizer
			-- to the buffer when a file is opened.
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
				callback = function()
					-- This command starts the color-highlighting process
					vim.cmd("ColorizerAttachToBuffer")
				end,
			})
		end,
	},
}

--[[
================================================================================
                              QUICK REFERENCE
================================================================================

This setup provides color visualization in two places:

1.  **In the Buffer (via `nvim-colorizer`)**:
    * Any text like `#FFF`, `rgb(255, 0, 0)`, or `bg-green-400` will
        have its *background* colored to match.
    * This is activated by the `ColorizerAttachToBuffer` command.

2.  **In the Completion Menu (via `tailwindcss-colorizer-cmp`)**:
    * When you type `bg-` and `nvim-cmp` shows suggestions...
    * ...you will see a small colored square next to each suggestion
        (e.g., `[■] bg-blue-500`, `[■] bg-blue-600`).

================================================================================
--]]
