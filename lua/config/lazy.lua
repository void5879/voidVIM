--[[
================================================================================
                        LAZY.NVIM PLUGIN MANAGER CONFIGURATION
================================================================================

This file sets up lazy.nvim, a modern plugin manager for Neovim that provides:
- Lazy loading (plugins load only when needed)
- Fast startup times
- Automatic dependency management
- Easy plugin installation and updates
- Git-based plugin management

WHAT THIS FILE DOES:
1. Bootstrap (automatically install) lazy.nvim if it's not present
2. Configure lazy.nvim with our preferences
3. Set up plugin loading from the "plugins" directory
4. Enable automatic plugin updates

PLUGIN ORGANIZATION:
- All individual plugin configurations should go in lua/plugins/*.lua
- Each plugin can have its own file (recommended for complex setups)
- Or group related plugins in single files

UNDERSTANDING LAZY LOADING:
Lazy.nvim only loads plugins when they're actually needed, which means:
- Faster Neovim startup (only essential plugins load immediately)
- Better memory usage (unused plugins don't consume resources)
- Conditional loading based on file types, commands, or key mappings
================================================================================
--]]

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                          BOOTSTRAP LAZY.NVIM                            │
-- └─────────────────────────────────────────────────────────────────────────┘

--[[
BOOTSTRAPPING EXPLAINED:
Bootstrapping means automatically installing lazy.nvim if it's not already
installed. This ensures that your Neovim configuration works on any fresh
system without manual plugin manager installation.

The process:
1. Check if lazy.nvim exists in the data directory
2. If not found, clone it from GitHub
3. Add it to Neovim's runtime path so it can be loaded
4. Handle any errors gracefully
--]]

-- Get the path where lazy.nvim should be installed
-- stdpath("data") returns the standard data directory for this Neovim installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is already installed
-- fs_stat() returns file information if the path exists, nil if it doesn't
-- (vim.uv or vim.loop) handles compatibility between different Neovim versions
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	-- ═══════════════════════════════════════════════════════════════════════
	--                         AUTOMATIC INSTALLATION
	-- ═══════════════════════════════════════════════════════════════════════

	print("📦 Installing lazy.nvim plugin manager...")

	-- GitHub repository URL for lazy.nvim
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"

	-- Clone lazy.nvim with optimized settings:
	-- --filter=blob:none : Partial clone (faster, smaller download)
	-- --branch=stable    : Use stable branch instead of main (more reliable)
	local clone_command = {
		"git",
		"clone",
		"--filter=blob:none", -- Partial clone for faster download
		"--branch=stable", -- Use stable branch for reliability
		lazyrepo, -- Source repository
		lazypath, -- Destination path
	}

	-- Execute the git clone command
	local out = vim.fn.system(clone_command)

	-- Check if the installation was successful
	if vim.v.shell_error ~= 0 then
		-- ═══════════════════════════════════════════════════════════════════
		--                           ERROR HANDLING
		-- ═══════════════════════════════════════════════════════════════════

		-- Display error message with colored text
		vim.api.nvim_echo({
			{ "❌ Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\n💡 Possible solutions:\n", "Normal" },
			{ "  • Check your internet connection\n", "Normal" },
			{ "  • Verify git is installed and accessible\n", "Normal" },
			{ "  • Try running the installation manually\n", "Normal" },
			{ "\nPress any key to exit...", "Question" },
		}, true, {})

		-- Wait for user input before exiting
		vim.fn.getchar()
		os.exit(1)
	else
		print("✅ Successfully installed lazy.nvim!")
	end
end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                       SETUP LAZY.NVIM RUNTIME PATH                      │
-- └─────────────────────────────────────────────────────────────────────────┘

-- Add lazy.nvim to Neovim's runtime path so it can be loaded
-- prepend() adds it to the beginning of the path for priority loading
vim.opt.rtp:prepend(lazypath)

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                         LAZY.NVIM CONFIGURATION                         │
-- └─────────────────────────────────────────────────────────────────────────┘

-- Load and configure lazy.nvim with our settings
require("lazy").setup({
	-- ═══════════════════════════════════════════════════════════════════════
	--                              PLUGIN SPECIFICATION
	-- ═══════════════════════════════════════════════════════════════════════

	spec = {
		-- Import all plugin configurations from the "plugins" directory
		-- This allows you to organize plugins in separate files:
		-- lua/plugins/colorscheme.lua, lua/plugins/lsp.lua, etc.
		{ import = "plugins" },
		{ import = "plugins.lsp" },

		-- You can also add individual plugins directly here:
		-- { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
		-- { "nvim-tree/nvim-tree.lua", cmd = "NvimTreeToggle" },
	},

	-- ═══════════════════════════════════════════════════════════════════════
	--                           INSTALLATION SETTINGS
	-- ═══════════════════════════════════════════════════════════════════════

	-- install = {
	-- Colorscheme to use during plugin installation
	-- This provides a pleasant experience while plugins are being installed
	-- Available built-in colorschemes: habamax, default, blue, darkblue,
	-- delek, desert, elflord, evening, industry, koehler, morning, murphy,
	-- pablo, peachpuff, ron, shine, slate, torte, zellner
	-- colorscheme = { "default" },  -- Fallback to default if habamax fails

	-- Don't install missing plugins automatically on startup
	-- Set to true if you want auto-installation (can slow startup)
	-- missing = true,
	-- },

	-- ═══════════════════════════════════════════════════════════════════════
	--                            UPDATE MANAGEMENT
	-- ═══════════════════════════════════════════════════════════════════════

	checker = {
		-- Automatically check for plugin updates
		-- This runs in the background and notifies you of available updates
		enabled = true,

		-- How often to check for updates (in hours)
		-- 24 = check once per day
		-- frequency = 3600, -- Check every hour (you can adjust this)

		-- Show notification when updates are available
		notify = true,
	},

	-- ═══════════════════════════════════════════════════════════════════════
	--                            PERFORMANCE SETTINGS
	-- ═══════════════════════════════════════════════════════════════════════

	performance = {
		cache = {
			enabled = true, -- Enable caching for faster subsequent loads
		},
		reset_packpath = true, -- Reset packpath to improve load times
		rtp = {
			-- Disable unused runtime path plugins for better performance
			disabled_plugins = {
				"gzip", -- Built-in gzip support
				"matchit", -- Enhanced % matching
				"matchparen", -- Highlight matching parentheses
				-- "netrwPlugin",    -- Built-in file explorer (we'll use better alternatives)
				"tarPlugin", -- Tar file support
				"tohtml", -- Convert to HTML
				"tutor", -- Built-in tutorial
				"zipPlugin", -- Zip file support
			},
		},
	},

	-- ═══════════════════════════════════════════════════════════════════════
	--                              UI CUSTOMIZATION
	-- ═══════════════════════════════════════════════════════════════════════

	ui = {
		-- Use a modern border style for floating windows
		border = "rounded", -- Options: "none", "single", "double", "rounded", "solid", "shadow"

		-- Custom icons for the lazy.nvim interface
		icons = {
			cmd = "⌘ ", -- Command
			config = "🛠 ", -- Configuration
			event = "📅 ", -- Event
			ft = "📂 ", -- Filetype
			init = "⚙ ", -- Initialization
			keys = "🗝 ", -- Key mappings
			plugin = "🔌 ", -- Plugin
			runtime = "💻 ", -- Runtime
			source = "📄 ", -- Source
			start = "🚀 ", -- Start
			task = "📋 ", -- Task
			lazy = "💤 ", -- Lazy loaded
			loaded = "✅ ", -- Loaded
			not_loaded = "⭕ ", -- Not loaded
		},

		-- Size of the lazy.nvim window
		size = { width = 0.8, height = 0.8 }, -- 80% of screen size
	},

	-- ═══════════════════════════════════════════════════════════════════════
	--                              DEVELOPMENT OPTIONS
	-- ═══════════════════════════════════════════════════════════════════════

	-- dev = {
	-- Path for local plugin development
	-- Useful if you're developing your own plugins
	-- path = "~/projects",

	-- Patterns to identify local development plugins
	-- patterns = {},  -- Empty by default

	-- Fallback to git if local plugin doesn't exist
	-- fallback = false,
	-- },

	-- ═══════════════════════════════════════════════════════════════════════
	--                              PROFILING & DEBUG
	-- ═══════════════════════════════════════════════════════════════════════

	profiling = {
		-- Set to true to enable startup profiling
		-- Use :Lazy profile to view results
		enabled = false,

		-- Threshold in milliseconds - only show plugins that take longer to load
		threshold = 5,
	},
})

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                         POST-SETUP CONFIGURATION                        │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ═══════════════════════════════════════════════════════════════════════════
--                              USEFUL KEYMAPS
-- ═══════════════════════════════════════════════════════════════════════════

-- These keymaps make it easy to manage plugins
-- Add these to your keymaps.lua file if desired:
--
-- vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Open Lazy plugin manager" })
-- vim.keymap.set("n", "<leader>li", "<cmd>Lazy install<cr>", { desc = "Install plugins" })
-- vim.keymap.set("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "Update plugins" })
-- vim.keymap.set("n", "<leader>ls", "<cmd>Lazy sync<cr>", { desc = "Sync plugins" })
-- vim.keymap.set("n", "<leader>lc", "<cmd>Lazy clean<cr>", { desc = "Clean unused plugins" })
-- vim.keymap.set("n", "<leader>lp", "<cmd>Lazy profile<cr>", { desc = "Profile plugin loading" })

-- ═══════════════════════════════════════════════════════════════════════════
--                              STATUS MESSAGE
-- ═══════════════════════════════════════════════════════════════════════════

-- Optional: Print a message when lazy.nvim is loaded
-- Uncomment the next line if you want to see confirmation
-- print("🚀 Lazy.nvim loaded successfully!")

--[[
================================================================================
                              PLUGIN ORGANIZATION GUIDE
================================================================================

RECOMMENDED PLUGIN STRUCTURE:
Your lua/plugins/ directory should contain individual plugin files:

📁 lua/plugins/
├── 🎨 colorscheme.lua          (themes and colors)
├── 🌳 treesitter.lua           (syntax highlighting)
├── 📁 lsp.lua                  (language server protocol)
├── 🔍 telescope.lua            (fuzzy finder)
├── 🗂️  nvim-tree.lua           (file explorer)
├── ⚡ completion.lua           (auto-completion)
├── 🔧 formatting.lua           (code formatting)
├── 📊 statusline.lua           (status bar)
├── 🎯 which-key.lua            (key binding helper)
└── 🛠️  utils.lua               (utility plugins)

================================================================================
                              LAZY LOADING STRATEGIES
================================================================================

LOADING TRIGGERS:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Trigger         │ When Plugin Loads                                        │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ lazy = false    │ Immediately on startup                                   │
│ event = "..."   │ When specific event occurs                               │
│ cmd = "..."     │ When command is executed                                 │
│ ft = "..."      │ When opening specific file type                          │
│ keys = "..."    │ When key mapping is pressed                              │
│ dependencies    │ When dependent plugin is loaded                          │
└─────────────────┴──────────────────────────────────────────────────────────┘

COMMON EVENTS:
- "VimEnter"      : After Vim has finished loading
- "BufRead"       : When reading a buffer
- "BufWinEnter"   : When entering a buffer in a window
- "InsertEnter"   : When entering insert mode
- "CmdlineEnter"  : When entering command line

EXAMPLE LAZY LOADING:
{
  "telescope.nvim",
  cmd = { "Telescope" },                    -- Load when :Telescope is run
  keys = { "<leader>ff", "<leader>fg" },    -- Load when these keys are pressed
}

{
  "nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },  -- Load when opening files
}

================================================================================
                              USEFUL COMMANDS
================================================================================

LAZY.NVIM COMMANDS:
:Lazy                 - Open the lazy.nvim interface
:Lazy install         - Install missing plugins
:Lazy update          - Update all plugins
:Lazy sync            - Install missing + update existing + clean unused
:Lazy clean           - Remove unused plugins
:Lazy check           - Check for plugin updates
:Lazy log             - Show recent updates
:Lazy profile         - Show plugin loading times
:Lazy debug           - Show debug information

SHORTCUTS IN LAZY INTERFACE:
- I : Install plugins
- U : Update plugins
- S : Sync (install + update + clean)
- X : Clean (remove unused)
- C : Check for updates
- L : Show log
- R : Restore a plugin
- P : Show profile information

--]]
