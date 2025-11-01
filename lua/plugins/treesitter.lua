--[[
================================================================================
                        TREESITTER SYNTAX HIGHLIGHTING CONFIGURATION
================================================================================

Treesitter provides advanced syntax highlighting, indentation, and text objects
for Neovim. It uses tree-sitter parsers to understand code structure better
than traditional regex-based highlighting.

WHAT TREESITTER DOES:
- Superior syntax highlighting with semantic understanding
- Smart indentation based on code structure
- Advanced text objects for easier code navigation
- Incremental selection for quick text selection
- Foundation for many other plugins (LSP, auto-pairs, etc.)

LOADING STRATEGY:
- Essential languages (C, Python, Java, JavaScript) are installed immediately
- Other languages are installed automatically when you open files of that type
- This keeps startup fast while ensuring good language support

PERFORMANCE BENEFITS:
- Faster startup (only loads essential parsers)
- Automatic installation means no manual maintenance
- Smart caching reduces repeated installations
================================================================================
--]]

return {
	{
		-- Modern syntax highlighting and language parsing
		"nvim-treesitter/nvim-treesitter",

		-- ═══════════════════════════════════════════════════════════════════════
		--                              LOADING STRATEGY
		-- ═══════════════════════════════════════════════════════════════════════

		-- Load when opening or reading files (lazy loading for better startup)
		event = { "BufReadPre", "BufNewFile" },

		-- Automatically update parsers when the plugin updates
		build = ":TSUpdate",

		-- ═══════════════════════════════════════════════════════════════════════
		--                              DEPENDENCIES
		-- ═══════════════════════════════════════════════════════════════════════

		dependencies = {
			-- Optional: Enhanced text objects (adds more powerful selection commands)
			-- Uncomment if you want advanced text object navigation
			-- "nvim-treesitter/nvim-treesitter-textobjects",
		},

		-- ═══════════════════════════════════════════════════════════════════════
		--                              MAIN CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════════

		config = function()
			-- Import treesitter configuration module
			local treesitter = require("nvim-treesitter.configs")

			-- Configure treesitter with our preferences
			treesitter.setup({

				-- ═════════════════════════════════════════════════════════════════
				--                          SYNTAX HIGHLIGHTING
				-- ═════════════════════════════════════════════════════════════════

				highlight = {
					-- Enable treesitter-based syntax highlighting
					-- This provides much better highlighting than Vim's default regex system
					enable = true,

					-- Disable Vim's built-in syntax highlighting to avoid conflicts
					-- Treesitter's highlighting is superior and more accurate
					additional_vim_regex_highlighting = false,

					-- Optional: Disable highlighting for large files (performance)
					-- Uncomment and adjust if you work with very large files
					-- disable = function(lang, buf)
					--   local max_filesize = 100 * 1024 -- 100 KB
					--   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					--   if ok and stats and stats.size > max_filesize then
					--     return true
					--   end
					-- end,
				},

				-- ═════════════════════════════════════════════════════════════════
				--                          SMART INDENTATION
				-- ═════════════════════════════════════════════════════════════════

				indent = {
					-- Enable treesitter-based indentation
					-- Provides smarter indentation based on code structure
					enable = true,

					-- Optional: Disable for specific languages if they have issues
					-- Some languages might have better indentation with built-in methods
					-- disable = { "python", "yaml" },
				},

				-- ═════════════════════════════════════════════════════════════════
				--                          LANGUAGE INSTALLATION
				-- ═════════════════════════════════════════════════════════════════

				-- Essential languages that are installed immediately
				-- These are common languages you're likely to use frequently
				ensure_installed = {
					-- Core languages (as requested)
					"c", -- C programming language
					"python", -- Python programming language
					"java", -- Java programming language
					"javascript", -- JavaScript programming language

					-- Essential web technologies (commonly used with JavaScript)
					"html", -- HTML markup
					"css", -- CSS styling
					"typescript", -- TypeScript (JavaScript with types)

					-- Configuration and markup (very common)
					"json", -- JSON data format
					"yaml", -- YAML configuration format

					-- Shell and system
					"bash", -- Bash shell scripting

					-- Neovim configuration essentials
					"lua", -- Lua (for Neovim config)
					"vim", -- Vim script
					"vimdoc", -- Vim documentation
					"query", -- Treesitter query language
				},

				-- Automatically install parsers when opening new file types
				-- This means you don't need to manually install parsers for occasional use
				auto_install = true,

				-- ═════════════════════════════════════════════════════════════════
				--                          INCREMENTAL SELECTION
				-- ═════════════════════════════════════════════════════════════════

				incremental_selection = {
					enable = true,
					keymaps = {
						-- Start selection with Ctrl+Space
						init_selection = "<C-space>",

						-- Expand selection with Ctrl+Space (incrementally select larger scope)
						-- First press: select word
						-- Second press: select statement/expression
						-- Third press: select function/class
						-- Fourth press: select entire file
						node_incremental = "<C-space>",

						-- Shrink selection with Ctrl+Backspace
						node_decremental = "<C-bs>",

						-- Disable scope incremental (not commonly used)
						scope_incremental = false,
					},
				},

				-- ═════════════════════════════════════════════════════════════════
				--                          PERFORMANCE OPTIONS
				-- ═════════════════════════════════════════════════════════════════

				-- Sync install (install parsers synchronously on startup)
				-- Set to false if you want faster startup but manual installation
				sync_install = false,

				-- Ignore missing parsers (don't show errors for unavailable languages)
				ignore_install = {},
			})
		end,
	},
}

--[[
================================================================================
                              LANGUAGE COVERAGE
================================================================================

IMMEDIATELY INSTALLED (ensure_installed):
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Language        │ Use Case                                                 │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ c               │ C programming, system programming                        │
│ python          │ Python development, data science, automation             │
│ java            │ Java development, enterprise applications                │
│ javascript      │ Web development, Node.js, frontend                       │
│ typescript      │ Type-safe JavaScript, modern web development             │
│ html            │ Web markup, templates                                    │
│ css             │ Styling, web design                                      │
│ json            │ Configuration files, API responses                       │
│ yaml            │ Configuration files, Docker, Kubernetes                  │
│ bash            │ Shell scripting, automation                              │
│ lua             │ Neovim configuration, scripting                          │
│ vim             │ Vim scripting, legacy configs                            │
│ vimdoc          │ Vim documentation                                        │
│ query           │ Treesitter queries                                       │
└─────────────────┴──────────────────────────────────────────────────────────┘

AUTO-INSTALLED ON FIRST USE:
Languages like Go, Rust, PHP, Ruby, Swift, Kotlin, Dart, etc. will be 
automatically installed when you first open a file of that type.

COMMON ADDITIONAL LANGUAGES (installed when encountered):
- go, rust, php, ruby, swift, kotlin, dart
- tsx (React TypeScript), jsx (React JavaScript)
- markdown, dockerfile, gitignore
- toml, ini, conf
- sql, prisma, graphql
- svelte, vue, astro
- And many more...

================================================================================
                              KEYMAPS REFERENCE  
================================================================================

INCREMENTAL SELECTION:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ Ctrl + Space    │ Start/expand selection incrementally                     │
│ Ctrl + Backspace│ Shrink selection                                         │
└─────────────────┴──────────────────────────────────────────────────────────┘

SELECTION PROGRESSION EXAMPLE:
1. Ctrl+Space (first press)  → Select current word
2. Ctrl+Space (second press) → Select current statement/expression  
3. Ctrl+Space (third press)  → Select current function/method
4. Ctrl+Space (fourth press) → Select current class/module

USEFUL COMMANDS:
:TSInstall <language>        - Manually install a language parser
:TSUninstall <language>      - Remove a language parser  
:TSUpdate                    - Update all installed parsers
:TSInstallInfo               - Show installation status of parsers
:TSBufEnable highlight       - Enable highlighting for current buffer
:TSBufDisable highlight      - Disable highlighting for current buffer

--]]
