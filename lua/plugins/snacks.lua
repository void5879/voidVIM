--[[
================================================================================
                        SNACKS.NVIM ALL-IN-ONE PLUGIN CONFIGURATION
================================================================================

Snacks.nvim is a comprehensive plugin collection by folke that replaces many
individual plugins with a unified, well-integrated solution. It provides:

CORE FEATURES:
- 🔍 Picker (fuzzy finder like Telescope)
- 📁 Explorer (file tree like nvim-tree)  
- 📊 Dashboard (startup screen)
- 🔔 Notifier (notification system)
- 📏 Indent guides and scope highlighting
- 📜 Scroll indicators
- 💻 Terminal integration
- 🔍 Word highlighting and navigation
- 🧘 Zen mode and zoom functionality
- 📝 Scratch buffers
- 🎨 And many more utilities

ADVANTAGES OF USING SNACKS:
- Unified configuration and theming
- Better integration between components
- Smaller total footprint than individual plugins
- Consistent keybindings across features
- Single source for updates and maintenance

REPLACES THESE COMMON PLUGINS:
- telescope.nvim (picker functionality)
- nvim-tree.lua (explorer)
- alpha-nvim (dashboard)
- nvim-notify (notifications)
- indent-blankline.nvim (indent guides)
- scrollbar.nvim (scroll indicators)
- toggleterm.nvim (terminal)
- zen-mode.nvim (focus mode)
================================================================================
--]]

return {
	{
		-- All-in-one plugin collection by folke
		"folke/snacks.nvim",

		-- ═══════════════════════════════════════════════════════════════════════
		--                              LOADING STRATEGY
		-- ═══════════════════════════════════════════════════════════════════════

		-- High priority ensures it loads early (important for core functionality)
		priority = 1000,

		-- Load immediately on startup (not lazy) since it provides core features
		lazy = false,

		-- ═══════════════════════════════════════════════════════════════════════
		--                              PLUGIN CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════════

		---@type snacks.Config
		opts = {

			-- ═════════════════════════════════════════════════════════════════════
			--                          CORE FEATURE MODULES
			-- ═════════════════════════════════════════════════════════════════════

			-- Big file handling (disable features for large files to maintain performance)
			bigfile = { enabled = true },

			-- Dashboard/startup screen (shows when opening Neovim without files)
			dashboard = {
				enabled = true,
				preset = {
					header = [[
 ▄█    █▄   ▄██████▄   ▄█  ████████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   
███    ███ ███    ███ ███  ███   ▀███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ 
███    ███ ███    ███ ███▌ ███    ███ ███    ███ ███▌ ███   ███   ███ 
███    ███ ███    ███ ███▌ ███    ███ ███    ███ ███▌ ███   ███   ███ 
███    ███ ███    ███ ███▌ ███    ███ ███    ███ ███▌ ███   ███   ███ 
███    ███ ███    ███ ███  ███    ███ ███    ███ ███  ███   ███   ███ 
███    ███ ███    ███ ███  ███   ▄███ ███    ███ ███  ███   ███   ███ 
 ▀██████▀   ▀██████▀  █▀   ████████▀   ▀██████▀  █▀    ▀█   ███   █▀  
                                                                      
]],
				},
			},

			-- File explorer (tree view for browsing files and directories)
			explorer = {
				enabled = true,
				---@class snacks.explorer.Config
				replace_netrw = true, -- Replace netrw with the snacks explorer
			},

			-- Indent guides (visual lines showing indentation levels)
			indent = { enabled = true },

			-- Input dialogs (enhanced input prompts for plugins)
			input = { enabled = true },

			-- Notification system (toast-style notifications)
			notifier = {
				enabled = true,
				timeout = 3000, -- Notifications disappear after 3 seconds
			},

			-- Fuzzy finder/picker (like telescope for finding files, text, etc.)
			picker = { enabled = true },

			-- Quick file operations (faster file reading for better performance)
			quickfile = { enabled = true },

			-- Scope highlighting (highlight current code block/function scope)
			scope = { enabled = true },

			-- Scroll indicators (show scrollbar and position indicators)
			scroll = { enabled = true },

			-- Status column (enhanced gutter with git signs, diagnostics, etc.)
			statuscolumn = { enabled = true },

			-- Word highlighting (highlight word under cursor and enable navigation)
			words = { enabled = true },

			-- ═════════════════════════════════════════════════════════════════════
			--                          STYLING CONFIGURATION
			-- ═════════════════════════════════════════════════════════════════════

			styles = {
				notification = {
					-- Custom notification styling can be added here
					-- wo = { wrap = true } -- Example: wrap long notifications
				},
			},
		},

		-- ═══════════════════════════════════════════════════════════════════════
		--                              KEY MAPPINGS
		-- ═══════════════════════════════════════════════════════════════════════

		keys = {

			-- ═════════════════════════════════════════════════════════════════════
			--                          MAIN PRODUCTIVITY SHORTCUTS
			-- ═════════════════════════════════════════════════════════════════════

			-- Smart file finder (most frequently used - gets the prime real estate)
			{
				"<leader><space>",
				function()
					Snacks.picker.smart()
				end,
				desc = "Smart Find Files",
			},

			-- Quick buffer switcher
			{
				"<leader>,",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},

			-- Text search across project
			{
				"<leader>/",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},

			-- Command history browser
			{
				"<leader>:",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},

			-- File explorer toggle
			{
				"<leader>fe",
				function()
					Snacks.explorer()
				end,
				desc = "File Explorer",
			},

			-- ═════════════════════════════════════════════════════════════════════
			--                          FILE FINDING (f prefix)
			-- ═════════════════════════════════════════════════════════════════════

			-- Buffer operations
			{
				"<leader>fb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},

			-- Configuration files (quick access to your Neovim config)
			{
				"<leader>fc",
				function()
					Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},

			-- Find files in current directory
			{
				"<leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},

			-- Find git-tracked files only
			{
				"<leader>fg",
				function()
					Snacks.picker.git_files()
				end,
				desc = "Find Git Files",
			},

			-- Project switcher (if you work with multiple projects)
			{
				"<leader>fp",
				function()
					Snacks.picker.projects()
				end,
				desc = "Projects",
			},

			-- Recently opened files
			{
				"<leader>fr",
				function()
					Snacks.picker.recent()
				end,
				desc = "Recent",
			},

			-- ═════════════════════════════════════════════════════════════════════
			--                          GIT INTEGRATION (g prefix)
			-- ═════════════════════════════════════════════════════════════════════

			-- Git branch switcher
			{
				"<leader>gb",
				function()
					Snacks.picker.git_branches()
				end,
				desc = "Git Branches",
			},

			-- Git commit history
			{
				"<leader>gl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git Log",
			},

			-- Git log for current line/selection
			{
				"<leader>gL",
				function()
					Snacks.picker.git_log_line()
				end,
				desc = "Git Log Line",
			},

			-- Git status (modified, staged, untracked files)
			{
				"<leader>gs",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git Status",
			},

			-- Git stash browser
			{
				"<leader>gS",
				function()
					Snacks.picker.git_stash()
				end,
				desc = "Git Stash",
			},

			-- Git diff viewer (see changes in hunks)
			{
				"<leader>gd",
				function()
					Snacks.picker.git_diff()
				end,
				desc = "Git Diff (Hunks)",
			},

			-- Git history for current file
			{
				"<leader>gf",
				function()
					Snacks.picker.git_log_file()
				end,
				desc = "Git Log File",
			},

			-- ═════════════════════════════════════════════════════════════════════
			--                          SEARCH OPERATIONS (s prefix)
			-- ═════════════════════════════════════════════════════════════════════

			-- Search in current buffer lines
			{
				"<leader>sb",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},

			-- Search across all open buffers
			{
				"<leader>sB",
				function()
					Snacks.picker.grep_buffers()
				end,
				desc = "Grep Open Buffers",
			},

			-- Project-wide text search
			-- { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },

			-- Search for word under cursor or visual selection
			{
				"<leader>sw",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Visual selection or word",
				mode = { "n", "x" },
			},

			-- ═════════════════════════════════════════════════════════════════════
			--                          SYSTEM SEARCH (s prefix continued)
			-- ═════════════════════════════════════════════════════════════════════

			-- Vim registers (clipboard history)
			{
				'<leader>s"',
				function()
					Snacks.picker.registers()
				end,
				desc = "Registers",
			},

			-- Search history
			{
				"<leader>s/",
				function()
					Snacks.picker.search_history()
				end,
				desc = "Search History",
			},

			-- Auto commands
			{
				"<leader>sa",
				function()
					Snacks.picker.autocmds()
				end,
				desc = "Autocmds",
			},

			-- Command history
			{
				"<leader>sc",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},

			-- Available commands
			{
				"<leader>sC",
				function()
					Snacks.picker.commands()
				end,
				desc = "Commands",
			},

			-- Diagnostic messages (errors, warnings, etc.)
			{
				"<leader>sd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},

			-- Diagnostics for current buffer only
			{
				"<leader>sD",
				function()
					Snacks.picker.diagnostics_buffer()
				end,
				desc = "Buffer Diagnostics",
			},

			-- Help pages
			{
				"<leader>shp",
				function()
					Snacks.picker.help()
				end,
				desc = "Help Pages",
			},

			-- Syntax highlighting groups
			{
				"<leader>sH",
				function()
					Snacks.picker.highlights()
				end,
				desc = "Highlights",
			},

			-- Available icons
			{
				"<leader>si",
				function()
					Snacks.picker.icons()
				end,
				desc = "Icons",
			},

			-- Jump list (places you've been)
			{
				"<leader>sj",
				function()
					Snacks.picker.jumps()
				end,
				desc = "Jumps",
			},

			-- Key mappings
			{
				"<leader>sk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},

			-- Location list
			{
				"<leader>sl",
				function()
					Snacks.picker.loclist()
				end,
				desc = "Location List",
			},

			-- Marks (bookmarked positions)
			{
				"<leader>sm",
				function()
					Snacks.picker.marks()
				end,
				desc = "Marks",
			},

			-- Manual pages
			{
				"<leader>sM",
				function()
					Snacks.picker.man()
				end,
				desc = "Man Pages",
			},

			-- Plugin specifications (search through lazy.nvim plugins)
			{
				"<leader>sp",
				function()
					Snacks.picker.lazy()
				end,
				desc = "Search for Plugin Spec",
			},

			-- Quickfix list
			{
				"<leader>sq",
				function()
					Snacks.picker.qflist()
				end,
				desc = "Quickfix List",
			},

			-- Resume last picker session
			{
				"<leader>sR",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume",
			},

			-- Undo tree (history of changes)
			{
				"<leader>su",
				function()
					Snacks.picker.undo()
				end,
				desc = "Undo History",
			},

			-- Colorscheme browser
			{
				"<leader>uC",
				function()
					Snacks.picker.colorschemes()
				end,
				desc = "Colorschemes",
			},

			-- ═════════════════════════════════════════════════════════════════════
			--                  LSP NAVIGATION (replaces default LSP keys)
			-- ═════════════════════════════════════════════════════════════════════

			-- Go to definition (where something is defined)
			{
				"gd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Goto Definition",
			},

			-- Go to declaration (different from definition in some languages)
			{
				"gD",
				function()
					Snacks.picker.lsp_declarations()
				end,
				desc = "Goto Declaration",
			},

			-- Find all references (where something is used)
			{
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},

			-- Go to implementation (concrete implementation of interface/abstract)
			{
				"gI",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Goto Implementation",
			},

			-- Go to type definition
			{
				"gy",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Goto T[y]pe Definition",
			},

			-- Document symbols (functions, classes, variables in current file)
			{
				"<leader>ss",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "LSP Symbols",
			},

			-- Workspace symbols (symbols across entire project)
			{
				"<leader>sS",
				function()
					Snacks.picker.lsp_workspace_symbols()
				end,
				desc = "LSP Workspace Symbols",
			},

			-- ═════════════════════════════════════════════════════════════════════
			--                          PRODUCTIVITY UTILITIES
			-- ═════════════════════════════════════════════════════════════════════

			-- Zen mode (distraction-free writing)
			{
				"<leader>z",
				function()
					Snacks.zen()
				end,
				desc = "Toggle Zen Mode",
			},

			-- Zoom current window (maximize/restore)
			{
				"<leader>Z",
				function()
					Snacks.zen.zoom()
				end,
				desc = "Toggle Zoom",
			},

			-- Scratch buffer (temporary notepad)
			{
				"<leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},

			-- Select from multiple scratch buffers
			{
				"<leader>S",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select Scratch Buffer",
			},

			-- Notification history
			-- NOTE: Conflicts with original <leader>n keymap - keeping snacks version
			{
				"<leader>n",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},

			-- Smart buffer deletion (closes buffer without closing window)
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},

			-- Rename file
			{
				"<leader>cR",
				function()
					Snacks.rename.rename_file()
				end,
				desc = "Rename File",
			},

			-- Browse current file/selection on GitHub/GitLab
			{
				"<leader>gB",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git Browse",
				mode = { "n", "v" },
			},

			-- LazyGit integration (full-featured git TUI)
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},

			-- Dismiss all notifications
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},

			-- ═════════════════════════════════════════════════════════════════════
			--                          TERMINAL INTEGRATION
			-- ═════════════════════════════════════════════════════════════════════

			-- Toggle terminal (Ctrl+/)
			{
				"<c-/>",
				function()
					Snacks.terminal()
				end,
				desc = "Toggle Terminal",
			},

			-- Alternative terminal toggle (Ctrl+_ for compatibility)
			-- { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },

			-- ═════════════════════════════════════════════════════════════════════
			--                          WORD NAVIGATION
			-- ═════════════════════════════════════════════════════════════════════

			-- Jump to next occurrence of word under cursor
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next Reference",
				mode = { "n", "t" },
			},

			-- Jump to previous occurrence of word under cursor
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Prev Reference",
				mode = { "n", "t" },
			},

			-- ═════════════════════════════════════════════════════════════════════
			--                          UTILITY WINDOWS
			-- ═════════════════════════════════════════════════════════════════════

			-- Show Neovim news/changelog
			{
				"<leader>N",
				desc = "Neovim News",
				function()
					Snacks.win({
						file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
						width = 0.6,
						height = 0.6,
						wo = {
							spell = false,
							wrap = false,
							signcolumn = "yes",
							statuscolumn = " ",
							conceallevel = 3,
						},
					})
				end,
			},
		},

		-- ═══════════════════════════════════════════════════════════════════════
		--                          INITIALIZATION SETUP
		-- ═══════════════════════════════════════════════════════════════════════

		init = function()
			-- Setup after other plugins load (VeryLazy event)
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- ═════════════════════════════════════════════════════════════════
					--                      DEBUG UTILITIES (GLOBAL HELPERS)
					-- ═════════════════════════════════════════════════════════════════

					-- Global debug inspection function (use with :lua dd(variable))
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end

					-- Global backtrace function (use with :lua bt())
					_G.bt = function()
						Snacks.debug.backtrace()
					end

					-- Override print function to use snacks for `:=` command
					if vim.fn.has("nvim-0.11") == 1 then
						vim._print = function(_, ...)
							dd(...)
						end
					else
						vim.print = _G.dd
					end

					-- ═════════════════════════════════════════════════════════════════
					--                      TOGGLE UTILITIES (u prefix for UI toggles)
					-- ═════════════════════════════════════════════════════════════════

					-- Toggle spell checking
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")

					-- Toggle line wrapping
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")

					-- Toggle relative line numbers
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")

					-- Toggle diagnostics (error/warning messages)
					Snacks.toggle.diagnostics():map("<leader>ud")

					-- Toggle line numbers
					Snacks.toggle.line_number():map("<leader>ul")

					-- Toggle concealment level (hide/show markup in markdown, etc.)
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>uc")

					-- Toggle treesitter (syntax highlighting)
					Snacks.toggle.treesitter():map("<leader>uT")

					-- Toggle light/dark background
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<leader>ub")

					-- Toggle LSP inlay hints (type information inline)
					Snacks.toggle.inlay_hints():map("<leader>uh")

					-- Toggle indent guides
					Snacks.toggle.indent():map("<leader>ug")

					-- Toggle dim inactive windows
					Snacks.toggle.dim():map("<leader>uD")
				end,
			})
		end,
	},
	-- NOTE: todo comments w/ snacks
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		optional = true,
		keys = {
			{
				"<leader>pt",
				function()
					require("snacks").picker.todo_comments()
				end,
				desc = "Todo",
			},
			{
				"<leader>pT",
				function()
					require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
				end,
				desc = "Todo/Fix/Fixme",
			},
		},
	},
}

--[[
================================================================================
                              FEATURE OVERVIEW
================================================================================

PICKER (FUZZY FINDER):
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Category        │ What You Can Find                                        │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ Files           │ Project files, git files, recent files, config files     │
│ Text Search     │ Grep project, search buffers, word under cursor          │
│ Git             │ Branches, commits, status, stash, diffs                  │
│ Code Navigation │ Symbols, references, definitions, implementations        │
│ System          │ Commands, help pages, keymaps, diagnostics               │
└─────────────────┴──────────────────────────────────────────────────────────┘

PRODUCTIVITY FEATURES:
- 🧘 Zen Mode: Distraction-free editing
- 📝 Scratch Buffers: Quick temporary notes  
- 🔔 Smart Notifications: Non-intrusive alerts
- 📊 Dashboard: Beautiful startup screen
- 🌳 File Explorer: Integrated file tree
- 💻 Terminal: Floating terminal integration

VISUAL ENHANCEMENTS:
- 📏 Indent Guides: Visual indentation levels
- 🎯 Scope Highlighting: Current code block highlighting
- 📜 Scroll Indicators: Enhanced scrollbar
- 🔍 Word Highlighting: Highlight word under cursor
- 🎨 Status Column: Enhanced gutter with git/diagnostics

TOGGLE UTILITIES (u prefix):
- Quickly toggle common editor features
- Spell check, line wrap, diagnostics
- Light/dark mode, relative numbers
- Indent guides, treesitter, inlay hints

--]]
