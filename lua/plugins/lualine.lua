--[[
================================================================================
                        LUALINE (STATUSLINE) CONFIGURATION
================================================================================

This file configures `lualine.nvim`, a fast and customizable statusline plugin
for Neovim. It replaces the default Vim statusline with a modern, icon-rich,
and informative bar.

WHAT LUALINE DOES:
- Shows the current mode (NORMAL, INSERT, etc.) with custom colors.
- Displays Git branch information.
- Shows file information (filename, modified status).
- Displays Git changes (diff) for the current file.
- Shows filetype and can display LSP diagnostics, lazy.nvim updates, etc.

LOADING STRATEGY:
- Loads lazily when a file is opened.
- Depends on `nvim-web-devicons` to display icons.
================================================================================
--]]

return {
	-- The main statusline plugin
	"nvim-lualine/lualine.nvim",

	-- ═══════════════════════════════════════════════════════════════════════
	--                              LOADING STRATEGY
	-- ═══════════════════════════════════════════════════════════════════

	event = { "BufReadPost", "BufNewFile" },

	-- ═══════════════════════════════════════════════════════════════════
	--                              DEPENDENCIES
	-- ═══════════════════════════════════════════════════════════════════

	dependencies = {
		-- Required for filetype icons and other UI elements
		"nvim-tree/nvim-web-devicons",
	},

	-- ═══════════════════════════════════════════════════════════════════════
	--                              MAIN CONFIGURATION
	-- ═══════════════════════════════════════════════════════════════════

	config = function()
		local lualine = require("lualine")
		-- Import lazy.status to show pending plugin updates
		local lazy_status = require("lazy.status")

		-- ═════════════════════════════════════════════════════════════════
		--                        CUSTOM COLOR PALETTE
		-- ═════════════════════════════════════════════════════════════════
		-- Define a color palette to be used in the custom theme
		local colors = {
			color0 = "#092236", -- Black
			color1 = "#ff5874", -- Red (used for replace mode)
			color2 = "#c3ccdc", -- Light Grey / Almost White text
			color3 = "#1c1e26", -- Dark background
			color6 = "#a1aab8", -- Inactive text
			color7 = "#828697", -- Old normal mode bg
			color8 = "#ae81ff", -- Purple (for visual mode)

			-- New colors for modes
			light_green = "#98c379", -- For INSERT mode
			blue = "#61afef", -- For NORMAL mode
			orange = "#d19a66", -- For COMMAND mode
			white = "#abb2bf", -- For TERMINAL mode
		}

		-- ═════════════════════════════════════════════════════════════════
		--                        CUSTOM LUALINE THEME
		-- ═════════════════════════════════════════════════════════════════
		-- Create a custom theme by defining colors for each mode
		local my_lualine_theme = {
			-- 'a', 'b', 'c' are sections *within* a mode component
			normal = {
				a = { fg = colors.color0, bg = colors.blue, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
				c = { fg = colors.color2, bg = colors.color3 },
			},
			insert = {
				a = { fg = colors.color0, bg = colors.light_green, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
			},
			visual = {
				a = { fg = colors.color0, bg = colors.color8, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
			},
			replace = {
				a = { fg = colors.color0, bg = colors.color1, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
			},
			command = {
				a = { fg = colors.color0, bg = colors.orange, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
			},
			terminal = {
				a = { fg = colors.color0, bg = colors.white, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
			},
			-- Theme for inactive windows
			inactive = {
				a = { fg = colors.color6, bg = colors.color3, gui = "bold" },
				b = { fg = colors.color6, bg = colors.color3 },
				c = { fg = colors.color6, bg = colors.color3 },
			},
		}

		-- ═════════════════════════════════════════════════════════════════
		--                      CUSTOM COMPONENT DEFINITIONS
		-- ═════════════════════════════════════════════════════════════════

		-- Custom mode component: Adds an icon and formats the string
		local mode = {
			"mode",
			fmt = function(str)
				-- Prepend an icon to the mode name
				return " " .. str
			end,
		}

		-- Custom diff component: Shows git changes with icons
		local diff = {
			"diff",
			colored = true,
			symbols = { added = " ", modified = " ", removed = " " }, -- Use Nerd Font icons
		}

		-- Custom filename component: Shows file status (e.g., read-only)
		local filename = {
			"filename",
			file_status = true,
			path = 0, -- 0 = filename only, 1 = relative path
		}

		-- Custom branch component: Adds an icon
		local branch = { "branch", icon = { "", color = { fg = "#A6D4DE" } }, "|" }

		-- ═════════════════════════════════════════════════════════════════
		--                        LUALINE FINAL SETUP
		-- ═════════════════════════════════════════════════════════════════

		lualine.setup({
			options = {
				icons_enabled = true,
				theme = my_lualine_theme, -- Apply our custom theme
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "|", right = "" },
			},
			-- Define the layout of the statusline
			sections = {
				-- Left side
				lualine_a = { mode },
				lualine_b = { branch },
				lualine_c = { diff, filename },

				-- Right side
				lualine_x = {
					{
						-- Show pending lazy.nvim updates
						lazy_status.updates,
						cond = lazy_status.has_updates, -- Only show if there are updates
						color = { fg = "#ff9e64" },
					},
					{ "filetype" }, -- Show filetype
				},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}

--[[
================================================================================
                              QUICK REFERENCE
================================================================================

STATUSLINE LAYOUT:

[A][B][C] ----------------------------------------------------------- [X]
|   |  |                                                              |
|   |  └─ (Git Diff) (Filename)                                       └─ (Lazy Updates) (Filetype)
|   |
|   └─ (Git Branch)
|
└─ (Mode)

MODE COLORS:
┌───────────┬──────────────────┬────────────────────┐
│ Mode      │ Color            │ Defined As         │
├───────────┼──────────────────┼────────────────────┤
│ NORMAL    │ Blue             │ colors.blue        │
│ INSERT    │ Light Green      │ colors.light_green │
│ VISUAL    │ Purple           │ colors.color8      │
│ REPLACE   │ Red              │ colors.color1      │
│ COMMAND   │ Orange           │ colors.orange      │
│ TERMINAL  │ White            │ colors.white       │
└───────────┴──────────────────┴────────────────────┘

================================================================================
--]]
