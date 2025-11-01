--[[
================================================================================
                        NVIM-WEB-DEVICONS CONFIGURATION
================================================================================

This is a simple but essential UI plugin. It provides a library of icons
that other plugins (like Telescope, nvim-tree, dashboard, etc.) can use.

WHAT DEVICONS DOES:
- Provides a common `require("nvim-web-devicons").get_icon(filename)` function.
- Allows UI plugins to display file-specific icons (e.g., a Python icon
  for `.py` files, a React icon for `.jsx` files).
- This plugin does nothing on its own; it is a *dependency* for other plugins.

NOTE:
- You must have a "Nerd Font" installed and enabled in your terminal
  for these icons to render correctly.
================================================================================
--]]

return {
	{
		-- The icon library plugin
		"nvim-tree/nvim-web-devicons",

		-- ═══════════════════════════════════════════════════════════════════
		--                              MAIN CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════

		-- `opts = {}` tells lazy.nvim to load the plugin and call its
		-- `setup` function with an empty table. This is the standard way
		-- to load the plugin with all its default settings.
		opts = {},
	},
}

--[[
================================================================================
                              QUICK REFERENCE
================================================================================

-   **Purpose**: Provides icons to other plugins.
-   **Visibility**: This plugin has no commands or UI. It works in the
    background.
-   **Requirement**: You MUST use a Nerd Font (like Fira Code Nerd Font,
    JetBrains Mono Nerd Font, etc.) in your terminal.

WHERE YOU WILL SEE THESE ICONS:
-   File explorers (e.g., `nvim-tree`)
-   File finders (e.g., `telescope.nvim`)
-   Statuslines (e.g., `lualine.nvim`)
-   Buffer tabs (e.g., `bufferline.nvim`)
-   Start screens (e.g., `dashboard.nvim`)

================================================================================
--]]
