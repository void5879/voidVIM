--[[
================================================================================
                        NEOVIM COLORSCHEME CONFIGURATION
================================================================================

This file manages all colorscheme plugins for Neovim. Only one colorscheme
should be actively loaded via `vim.cmd("colorscheme ...")` at a time.

This configuration uses `lazy.nvim` to manage the plugins.

ORGANIZATION:
- monochrome.nvim (Installed, Inactive)
- github-nvim-theme (Installed, **Active**)
- kanagawa.nvim (Installed, Inactive)

ACTIVE THEME:
The currently active theme is `github_dark_high_contrast`.
Other colorschemes are set up and installed, but their final
`vim.cmd` call is commented out. To switch themes, comment out
the active one and uncomment your desired one.
================================================================================
--]]

return {

	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                       1. MONOCHROME.NVIM (INACTIVE)                     │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		-- A minimal, simple monochrome (black and white) colorscheme
		"kdheepak/monochrome.nvim",

		-- ═══════════════════════════════════════════════════════════════════
		--                              LOADING STRATEGY
		-- ═══════════════════════════════════════════════════════════════════

		-- Load this plugin lazily when a buffer is opened or a new file is created
		event = { "BufReadPost", "BufNewFile" },

		-- ═══════════════════════════════════════════════════════════════════
		--                              CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════
		config = function()
			-- This theme is installed but not activated.
			-- To use it, uncomment the line below and comment out other
			-- `vim.cmd("colorscheme ...")` lines in this file.
			-- vim.cmd("colorscheme monochrome")
		end,
	},

	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                     2. GITHUB-NVIM-THEME (ACTIVE)                       │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		-- The official GitHub colorscheme for Neovim
		"projekt0n/github-nvim-theme",

		-- Use a custom name for the plugin directory (optional)
		name = "github-theme",

		-- ═══════════════════════════════════════════════════════════════════
		--                              LOADING STRATEGY
		-- ═══════════════════════════════════════════════════════════════════

		-- `lazy = false` means this plugin will ALWAYS be loaded on startup.
		-- This is crucial for your primary colorscheme to avoid "flashing"
		-- of the default theme.
		lazy = false,

		-- `priority = 1000` ensures this plugin loads BEFORE other plugins.
		-- This guarantees the colors are set correctly before UI elements
		-- like the statusline or bufferline try to load.
		priority = 1000,

		-- ═══════════════════════════════════════════════════════════════════
		--                              CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════
		config = function()
			-- Load the plugin's setup function (even if empty)
			require("github-theme").setup({
				-- Configuration options would go here
				-- e.g., { theme_style = "dark_high_contrast" }
				-- This config is minimal as the theme is set directly below.
			})

			-- ═════════════════════════════════════════════════════════════
			--                         ACTIVATE THEME
			-- ═════════════════════════════════════════════════════════════
			-- This command applies the colorscheme, making it active.
			vim.cmd("colorscheme github_dark_high_contrast")
		end,
	},

	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                       3. KANAGAWA.NVIM (INACTIVE)                       │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		-- A sophisticated colorscheme inspired by the "Great Wave" painting
		"rebelot/kanagawa.nvim",

		-- ═══════════════════════════════════════════════════════════════════
		--                              CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════
		config = function()
			-- Load the plugin's setup function
			require("kanagawa").setup({

				-- ═════════════════════════════════════════════════════════
				--                        CORE SETTINGS
				-- ═════════════════════════════════════════════════════════

				compile = false, -- Don't pre-compile the theme (loads faster)
				undercurl = true, -- Enable undercurls for diagnostics
				transparent = true, -- Enable transparent background
				dimInactive = false, -- Do not dim inactive windows
				terminalColors = true, -- Set colors for the built-in terminal

				-- ═════════════════════════════════════════════════════════
				--                        STYLE SETTINGS
				-- ═════════════════════════════════════════════════════════

				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = false },
				statementStyle = { bold = true },
				typeStyle = {},

				-- ═════════════════════════════════════════════════════════
				--                    COLOR CUSTOMIZATION
				-- ═════════════════════════════════════════════════════════
				colors = {
					palette = {},
					theme = {
						wave = {},
						dragon = {},
						all = {
							ui = {
								-- Set gutter background to "none" to respect transparency
								bg_gutter = "none",
								-- This value is not standard in Kanagawa,
								-- 'border' is usually a color, not a style.
								-- Assuming this is intended for an override.
								border = "rounded",
							},
						},
					},
				},

				-- ═════════════════════════════════════════════════════════
				--                  HIGHLIGHT GROUP OVERRIDES
				-- ═════════════════════════════════════════════════════════
				-- This function allows you to customize specific UI elements
				overrides = function(colors)
					local theme = colors.theme
					return {
						-- Make floating windows (like LSP hover) transparent
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },

						-- Make the completion menu (Pmenu) transparent
						Pmenu = { fg = theme.ui.shade0, bg = "NONE" },
						PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
						PmenuSbar = { bg = theme.ui.bg_m1 },
						PmenuThumb = { bg = theme.ui.bg_p2 },

						-- Define a custom highlight group for dark, dimmed backgrounds
						NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

						-- Apply dark background to specific plugins
						LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
						MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

						-- Customize Telescope colors
						TelescopeTitle = { fg = theme.ui.special, bold = true },
						TelescopePromptBorder = { fg = theme.ui.special },
						TelescopeResultsNormal = { fg = theme.ui.fg_dim },
						TelescopeResultsBorder = { fg = theme.ui.special },
						TelescopePreviewBorder = { fg = theme.ui.special },
					}
				end,

				-- ═════════════════════════════════════════════════════════
				--                         THEME SELECTION
				-- ═════════════════════════════════════════════════════════

				theme = "wave", -- Default theme to use
				background = {
					dark = "wave", -- Use "wave" theme for `set background=dark`
					light = "lotus", -- (Example) Use "lotus" for `set background=light`
				},
			})

			-- This theme is installed but not activated.
			-- To use it, uncomment the line below and comment out other
			-- `vim.cmd("colorscheme ...")` lines in this file.
			-- vim.cmd("colorscheme kanagawa")
		end,
	},
}

--[[
================================================================================
                              QUICK REFERENCE
================================================================================

COLORSCHEME STATUS:
┌───────────────────────────┬──────────────────┬─────────────────────────────┐
│ Plugin                    │ Status           │ How to Activate             │
├───────────────────────────┼──────────────────┼─────────────────────────────┤
│ monochrome.nvim           │ Installed        │ Uncomment line 29           │
│ github-nvim-theme         │ **ACTIVE**       │ **Currently active**        │
│ kanagawa.nvim             │ Installed        │ Uncomment line 186          │
└───────────────────────────┴──────────────────┴─────────────────────────────┘

WHY `lazy=false` AND `priority=1000` for GITHUB-THEME?
- `lazy = false`: Ensures the theme loads immediately on startup. If this were
  `true` or set to an `event`, you would see the default Neovim theme first,
  which would then "flash" to the GitHub theme, which is undesirable.
- `priority = 1000`: Makes `lazy.nvim` load this plugin *before* all other
  plugins (like statuslines, treesitter, etc.). This ensures that when other
  plugins load, the colors they need are already defined, preventing errors
  or visual glitches.

TRANSPARENCY IN KANAGAWA:
- The `transparent = true` setting (line 104) is the main switch.
- Overrides for `NormalFloat` (line 140) and `Pmenu` (line 145) are added
  to ensure that floating windows and the completion menu also respect
  transparency, which they might not do by default.
- `bg_gutter = "none"` (line 126) is also set for full transparency.

--]]
