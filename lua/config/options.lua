--[[
================================================================================
                        NEOVIM OPTIONS CONFIGURATION
================================================================================

This file configures Neovim's built-in options and settings to create an
optimal editing environment. These settings affect how Neovim behaves,
looks, and feels during use.

ORGANIZATION:
- General Settings (basic behavior)
- Indentation & Text Formatting
- File Handling & Backup
- User Interface & Display
- Search Configuration
- Performance & Miscellaneous
- Auto Commands (automatic behaviors)

OPTIONS EXPLAINED:
vim.opt.setting = value    -- Standard way to set options
vim.g.setting = value      -- Global variables
vim.o.setting = value      -- Alternative way for certain options

Note: Leader keys are now handled in keymaps.lua to avoid conflicts
================================================================================
--]]

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                          INDENTATION & FORMATTING                       │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ═══════════════════════════════════════════════════════════════════════════
--                              TAB SETTINGS
-- ═══════════════════════════════════════════════════════════════════════════

-- Number of visual spaces per tab character
-- When you see a tab in a file, it displays as 2 spaces wide
vim.opt.tabstop = 2

-- Number of spaces used when editing (inserting/deleting tabs)
-- When you press Tab in insert mode, it inserts 2 spaces worth
vim.opt.softtabstop = 2

-- Convert tabs to spaces automatically
-- This ensures consistent spacing across different editors/systems
vim.opt.expandtab = true

-- Number of spaces used for each indentation level
-- When you use >> or << commands, it indents by 2 spaces
vim.opt.shiftwidth = 2

-- ═══════════════════════════════════════════════════════════════════════════
--                            SMART INDENTATION
-- ═══════════════════════════════════════════════════════════════════════════

-- Automatically indent new lines intelligently based on syntax
-- Useful for programming - adds proper indentation after { } etc.
vim.opt.smartindent = true

-- Copy the indentation from the current line when starting a new line
-- Maintains consistent indentation levels as you type
vim.opt.autoindent = true

-- Preserve indentation when wrapping long lines
-- If a line wraps, the continuation maintains proper visual alignment
vim.opt.breakindent = true

-- ═══════════════════════════════════════════════════════════════════════════
--                               LINE WRAPPING
-- ═══════════════════════════════════════════════════════════════════════════

-- Disable automatic line wrapping for better code readability
-- Long lines will extend beyond screen width instead of wrapping
vim.opt.wrap = false

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                       FILE HANDLING & BACKUP SETTINGS                   │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ═══════════════════════════════════════════════════════════════════════════
--                             SWAP & BACKUP FILES
-- ═══════════════════════════════════════════════════════════════════════════

-- Disable swap files (temporary files created during editing)
-- Modern systems have enough RAM, and swap files can cause issues
vim.opt.swapfile = false

-- Disable backup files (copies of original files)
-- We rely on version control (git) and undo history instead
vim.opt.backup = false

-- ═══════════════════════════════════════════════════════════════════════════
--                               UNDO HISTORY
-- ═══════════════════════════════════════════════════════════════════════════

-- Directory to store persistent undo history
-- This allows you to undo changes even after reopening a file
local home = os.getenv("HOME")
if home then
	vim.opt.undodir = home .. "/.vim/undodir"
else
	-- Fallback for Windows or systems without HOME
	vim.opt.undodir = vim.fn.stdpath("cache") .. "/undodir"
end

-- Enable persistent undo across sessions
-- Your undo history survives closing and reopening files
vim.opt.undofile = true

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                        USER INTERFACE & DISPLAY                         │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ═══════════════════════════════════════════════════════════════════════════
--                              LINE NUMBERS
-- ═══════════════════════════════════════════════════════════════════════════

-- Show absolute line numbers in the left gutter
-- Helps with navigation and debugging
vim.opt.number = true

-- Show relative line numbers (distance from current line)
-- Makes it easy to use motion commands like "5j" (jump 5 lines down)
vim.opt.relativenumber = true

-- ═══════════════════════════════════════════════════════════════════════════
--                              VISUAL ENHANCEMENTS
-- ═══════════════════════════════════════════════════════════════════════════

-- Hide the mode indicator (INSERT, VISUAL, etc.) in command line
-- Status line plugins typically show this information more elegantly
vim.opt.showmode = false

-- Enable 24-bit RGB color support for better themes and syntax highlighting
-- Allows for more vibrant and accurate colors in modern terminals
vim.opt.termguicolors = true

-- Always show the sign column (left margin for git signs, diagnostics, etc.)
-- Prevents the editor from jumping when signs appear/disappear
vim.opt.signcolumn = "yes"

-- Highlight the current line for better cursor visibility
-- Makes it easier to see which line you're currently editing
vim.opt.cursorline = true

-- Keep at least 8 lines visible above/below cursor when scrolling
-- Provides context while navigating through files
vim.opt.scrolloff = 8

-- Keep at least 8 columns visible left/right of cursor when scrolling horizontally
-- Useful when working with long lines and horizontal scrolling
vim.opt.sidescrolloff = 8

-- ═══════════════════════════════════════════════════════════════════════════
--                              COMPLETION MENU
-- ═══════════════════════════════════════════════════════════════════════════

-- Configure completion popup behavior
-- "menuone" = show menu even for single match
-- "noselect" = don't auto-select the first item
vim.opt.completeopt = { "menuone", "noselect" }

-- ═══════════════════════════════════════════════════════════════════════════
--                              WINDOW SPLITTING
-- ═══════════════════════════════════════════════════════════════════════════

-- New horizontal splits appear below current window (more intuitive)
vim.opt.splitbelow = true

-- New vertical splits appear to the right of current window (more intuitive)
vim.opt.splitright = true

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                           SEARCH CONFIGURATION                          │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ═══════════════════════════════════════════════════════════════════════════
--                              SEARCH BEHAVIOR
-- ═══════════════════════════════════════════════════════════════════════════

-- Highlight search matches as you type (incremental search)
-- Shows matches in real-time as you type your search pattern
vim.opt.incsearch = true

-- Keep search matches highlighted after search is complete
-- All matching text remains highlighted until cleared
vim.opt.hlsearch = true

-- Ignore case in search patterns by default
-- Searching for "hello" will match "Hello", "HELLO", etc.
vim.opt.ignorecase = true

-- Override ignorecase if search contains uppercase letters
-- Searching for "Hello" will only match "Hello", not "hello"
-- Provides intelligent case handling: lowercase = case insensitive, mixed case = case sensitive
vim.opt.smartcase = true

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                         PERFORMANCE & OPTIMIZATION                      │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ═══════════════════════════════════════════════════════════════════════════
--                              REDRAW OPTIMIZATION
-- ═══════════════════════════════════════════════════════════════════════════

-- Don't redraw screen during macros, registers, and other non-typed commands
-- Improves performance during complex operations and macro execution
vim.opt.lazyredraw = true

-- Reduce update time for better responsiveness
-- Time in milliseconds to wait before triggering events (like showing diagnostics)
-- Default is 4000ms, 50ms makes the editor feel much more responsive
vim.opt.updatetime = 50

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                            FOLDING CONFIGURATION                        │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ═══════════════════════════════════════════════════════════════════════════
--                              CODE FOLDING SETUP
-- ═══════════════════════════════════════════════════════════════════════════

-- Enable folding functionality
-- Allows you to collapse/expand sections of code for better organization
vim.opt.foldenable = true

-- Use manual folding method by default
-- You can create folds manually with zf command, or plugins can set up automatic folding
vim.opt.foldmethod = "manual"

-- Set high fold level (99) so files open with all folds expanded
-- Lower numbers would start with more code folded by default
vim.opt.foldlevel = 99

-- Don't show fold column (the left margin showing fold indicators)
-- Saves screen space; you can still use folding commands
vim.opt.foldcolumn = "0"

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                         MISCELLANEOUS SETTINGS                          │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ═══════════════════════════════════════════════════════════════════════════
--                              CLIPBOARD INTEGRATION
-- ═══════════════════════════════════════════════════════════════════════════

-- Use system clipboard for yank/paste operations
-- Allows seamless copy/paste between Neovim and other applications
vim.opt.clipboard:append("unnamedplus")

-- ═══════════════════════════════════════════════════════════════════════════
--                              MOUSE SUPPORT
-- ═══════════════════════════════════════════════════════════════════════════

-- Enable mouse support in all modes
-- Allows clicking to position cursor, select text, resize windows, etc.
vim.opt.mouse = "a"

-- ═══════════════════════════════════════════════════════════════════════════
--                              SPECIAL CHARACTERS
-- ═══════════════════════════════════════════════════════════════════════════

-- Include @ and - as valid filename characters
-- Useful for modern web development (npm packages, email addresses in filenames)
vim.opt.isfname:append("@-@")

-- ═══════════════════════════════════════════════════════════════════════════
--                              EDITOR CONFIG SUPPORT
-- ═══════════════════════════════════════════════════════════════════════════

-- Enable EditorConfig support for consistent coding styles across projects
-- Automatically applies .editorconfig settings when present
vim.g.editorconfig = true

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                            AUTO COMMANDS                                │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ═══════════════════════════════════════════════════════════════════════════
--                              HIGHLIGHT ON YANK
-- ═══════════════════════════════════════════════════════════════════════════

-- Create an auto command group for yank highlighting
-- Groups help organize and manage auto commands
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

-- Highlight yanked (copied) text briefly to provide visual feedback
-- Makes it clear what text was just copied
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_group,
	pattern = "*",
	desc = "Highlight yanked text briefly",
	callback = function()
		vim.highlight.on_yank({
			timeout = 200, -- Highlight duration in milliseconds
			visual = true, -- Also highlight in visual mode
		})
	end,
})

-- ═══════════════════════════════════════════════════════════════════════════
--                            LINE LENGTH INDICATOR
-- ═══════════════════════════════════════════════════════════════════════════

-- REMOVED: vim.opt.colorcolumn = "80"
-- This was the "annoying line" that showed at 80 characters
-- Commenting this out removes the vertical line indicator

--[[
================================================================================
                              QUICK REFERENCE
================================================================================

INDENTATION SETTINGS:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Setting         │ Purpose                                                  │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ tabstop = 2     │ Tab characters appear 2 spaces wide                      │
│ softtabstop = 2 │ Tab key inserts 2 spaces                                 │
│ expandtab       │ Convert tabs to spaces                                   │
│ shiftwidth = 2  │ Indentation commands use 2 spaces                        │
│ smartindent     │ Smart indentation for programming                        │
│ autoindent      │ Copy indentation from current line                       │
└─────────────────┴──────────────────────────────────────────────────────────┘

UI ENHANCEMENTS:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Setting         │ Purpose                                                  │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ number          │ Show absolute line numbers                               │
│ relativenumber  │ Show relative line numbers                               │
│ cursorline      │ Highlight current line                                   │
│ signcolumn      │ Always show gutter for git/diagnostics                   │
│ termguicolors   │ Enable 24-bit colors                                     │ 
│ scrolloff = 8   │ Keep 8 lines visible around cursor                       │
└─────────────────┴──────────────────────────────────────────────────────────┘

SEARCH SETTINGS:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Setting         │ Purpose                                                  │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ incsearch       │ Highlight matches as you type                            │
│ hlsearch        │ Keep matches highlighted                                 │
│ ignorecase      │ Case-insensitive search by default                       │
│ smartcase       │ Case-sensitive if pattern has uppercase                  │
└─────────────────┴──────────────────────────────────────────────────────────┘

PERFORMANCE:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Setting         │ Purpose                                                  │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ lazyredraw      │ Don't redraw during macros (faster)                      │
│ updatetime = 50 │ Faster response to events                                │
│ swapfile = false│ No swap files (cleaner, faster)                          │
│ backup = false  │ No backup files (use git instead)                        │
└─────────────────┴──────────────────────────────────────────────────────────┘

FILE HANDLING:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Setting         │ Purpose                                                  │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ undofile        │ Persistent undo history across sessions                  │
│ splitbelow      │ New horizontal splits open below                         │
│ splitright      │ New vertical splits open to the right                    │
│ clipboard       │ Use system clipboard                                     │
└─────────────────┴──────────────────────────────────────────────────────────┘

--]]
