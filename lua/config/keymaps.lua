--[[
================================================================================
                        NEOVIM KEYMAPS CONFIGURATION
================================================================================

This file contains custom key mappings for Neovim to improve workflow efficiency.
All mappings are designed to be intuitive and follow common conventions.

LEGEND:
  <leader>    = Space bar (our main prefix key)
  <C-x>       = Ctrl + x
  <S-x>       = Shift + x
  <M-x>       = Alt + x (Meta key)
  <CR>        = Enter key
  <Esc>       = Escape key

KEY MAPPING STRUCTURE:
  vim.keymap.set(mode, key_combination, command, options)
  
  Modes:
    "n" = Normal mode (default vim mode for navigation/commands)
    "v" = Visual mode (when text is selected)
    "i" = Insert mode (when typing text)
    "x" = Visual block mode
    "t" = Terminal mode

OPTIONS EXPLAINED:
  noremap = true   : Prevents recursive mapping (safer)
  silent = true    : Don't show command in command line
  desc = "text"    : Description for which-key plugin
================================================================================
--]]

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                           GLOBAL SETTINGS                               │
-- └─────────────────────────────────────────────────────────────────────────┘

-- Default options for most keymaps (non-recursive and silent)
local opts = { noremap = true, silent = true }

-- Set leader keys (the prefix key for custom commands)
-- Space is chosen because it's easily accessible and unused in normal mode
vim.g.mapleader = " " -- Global leader key
vim.g.maplocalleader = " " -- Local leader key (for buffer-specific mappings)

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                           LEADER KEY SETUP                              │
-- └─────────────────────────────────────────────────────────────────────────┘

-- Disable Space bar's default behavior since it's now our leader key
-- This prevents accidental cursor movement when using leader combinations
vim.keymap.set("n", "<leader>", "<nop>", opts)
vim.keymap.set("v", "<leader>", "<nop>", opts)

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                          NORMAL MODE MAPPINGS                           │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ═══════════════════════════════════════════════════════════════════════════
--                              BASIC EDITING
-- ═══════════════════════════════════════════════════════════════════════════

-- Redo command (opposite of undo)
-- Default: Ctrl+r, Enhanced: U (easier to reach)
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo last undone change" })

-- Quick file operations
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save current file", silent = false })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit current window", silent = false })
vim.keymap.set("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Save and quit", silent = false })
vim.keymap.set("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all windows", silent = false })

-- Force quit without saving (emergency exit)
vim.keymap.set("n", "<leader>qq", "<cmd>q!<cr>", { desc = "Force quit without saving", silent = false })

-- ═══════════════════════════════════════════════════════════════════════════
--                           SEARCH AND REPLACE
-- ═══════════════════════════════════════════════════════════════════════════

-- Mass replace word under cursor throughout the entire file
-- Places cursor in replace position, ready to type new word
-- Explanation: %s = substitute in entire file, \< \> = word boundaries
--              <C-r><C-w> = insert word under cursor, gI = global case-sensitive
vim.keymap.set(
	"n",
	"<leader>sr",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor globally", silent = false }
)

-- Clear search highlighting (removes yellow highlights after search)
vim.keymap.set("n", "<Esc>", "<cmd>nohl<CR>", { desc = "Clear search highlights" })

-- ═══════════════════════════════════════════════════════════════════════════
--                            NAVIGATION ENHANCED
-- ═══════════════════════════════════════════════════════════════════════════

-- Navigate between split windows using Ctrl + Arrow keys
vim.keymap.set("n", "<C-Left>", "<cmd>wincmd h<CR>", { desc = "Move to left split" })
vim.keymap.set("n", "<C-Right>", "<cmd>wincmd l<CR>", { desc = "Move to right split" })
vim.keymap.set("n", "<C-Up>", "<cmd>wincmd k<CR>", { desc = "Move to upper split" })
vim.keymap.set("n", "<C-Down>", "<cmd>wincmd j<CR>", { desc = "Move to lower split" })

-- Navigate between open buffers (files) using Shift + Arrow keys
vim.keymap.set("n", "<S-Right>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Left>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Alternative buffer navigation (commonly used)
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer (Tab)" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer (Shift+Tab)" })

-- Close current buffer without closing the window
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>X", "<cmd>bdelete!<CR>", { desc = "Force close buffer (unsaved changes)" })

-- ═══════════════════════════════════════════════════════════════════════════
--                          SCROLLING WITH CENTERING
-- ═══════════════════════════════════════════════════════════════════════════

-- Page up/down while keeping cursor centered on screen
-- C-u = half page up, C-d = half page down, zz = center cursor line
vim.keymap.set("n", "<S-Up>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "<S-Down>", "<C-d>zz", { desc = "Scroll down and center" })

-- Keep cursor centered when jumping through search results
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- ═══════════════════════════════════════════════════════════════════════════
--                           CLIPBOARD OPERATIONS
-- ═══════════════════════════════════════════════════════════════════════════

-- Paste without losing what's in the clipboard
-- Normally, when you paste over selected text, your clipboard gets replaced
-- This mapping keeps your original clipboard content intact
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without losing clipboard" })

-- System clipboard integration (works with Ctrl+C/Ctrl+V from other apps)
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>dd", '"_d', { desc = "Delete without copying to clipboard" })

-- Paste from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>P", '"+p', { desc = "Paste from system clipboard" })

-- ═══════════════════════════════════════════════════════════════════════════
--                           WINDOW/SPLIT MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════

-- Create new splits
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically (side by side)" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally (top/bottom)" })

-- Legacy mapping for vertical split (alternative method)
-- vim.keymap.set("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "Vertical split (alternative)" })

-- Resize splits
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make all splits equal size" })
vim.keymap.set("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "Toggle split maximization" })

-- Close splits
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split window" })

-- Resize splits with arrow keys
vim.keymap.set("n", "<C-S-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-S-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-S-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-S-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- ═══════════════════════════════════════════════════════════════════════════
--                              TAB MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════

-- Tab navigation and management
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tmf", "<cmd>tabmove +1<CR>", { desc = "Move tab forward" })
vim.keymap.set("n", "<leader>tmb", "<cmd>tabmove -1<CR>", { desc = "Move tab backward" })

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                          VISUAL MODE MAPPINGS                           │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ═══════════════════════════════════════════════════════════════════════════
--                          TEXT MANIPULATION IN VISUAL MODE
-- ═══════════════════════════════════════════════════════════════════════════

-- Move selected lines up and down while maintaining selection and indentation
-- J and K are commonly used for this, but Ctrl+arrows are more intuitive
vim.keymap.set("v", "<C-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<C-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Alternative with J/K for vim purists
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Indent/outdent selected text while maintaining selection
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                         INSERT MODE MAPPINGS                            │
-- └─────────────────────────────────────────────────────────────────────────┘

-- Quick escape from insert mode (alternative to Esc key)
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("i", "kj", "<Esc>", { desc = "Exit insert mode" })

-- Navigate in insert mode (sometimes useful for small movements)
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move left in insert mode" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move right in insert mode" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move down in insert mode" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move up in insert mode" })

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                         TERMINAL MODE MAPPINGS                          │
-- └─────────────────────────────────────────────────────────────────────────┘

-- Easy escape from terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Navigate between windows while in terminal mode
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<CR>", { desc = "Move to left window from terminal" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<CR>", { desc = "Move to bottom window from terminal" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<CR>", { desc = "Move to top window from terminal" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<CR>", { desc = "Move to right window from terminal" })

--[[
================================================================================
                              QUICK REFERENCE
================================================================================

LEADER KEY MAPPINGS (<leader> = Space):
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <leader>w       │ Save current file                                        │
│ <leader>q       │ Quit current window                                      │
│ <leader>wq      │ Save and quit                                            │
│ <leader>x       │ Close current buffer                                     │
│ <leader>s       │ Replace word under cursor globally                       │ 
│ <leader>y       │ Copy to system clipboard                                 │
│ <leader>p       │ Paste without losing clipboard                           │
│ <leader>v       │ Create vertical split                                    │
│ <leader>sv      │ Split window vertically                                  │
│ <leader>sh      │ Split window horizontally                                │
│ <leader>se      │ Make splits equal size                                   │
│ <leader>sx      │ Close current split                                      │ 
└─────────────────┴──────────────────────────────────────────────────────────┘

NAVIGATION:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ Ctrl + Arrows   │ Navigate between splits                                  │
│ Shift + Arrows  │ Navigate between buffers                                 │
│ Shift + Up/Down │ Scroll and center cursor                                 │
│ Tab / Shift+Tab │ Next/Previous buffer                                     │ 
│ n / N           │ Next/Previous search result (centered)                   │
└─────────────────┴──────────────────────────────────────────────────────────┘

VISUAL MODE:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ Ctrl+Up/Down    │ Move selected lines up/down                              │
│ < / >           │ Indent left/right and maintain selection                 │
│ J / K           │ Move selected lines down/up (alternative)                │
└─────────────────┴──────────────────────────────────────────────────────────┘

SPECIAL KEYS:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ U               │ Redo (instead of Ctrl+r)                                 │
│ Esc             │ Clear search highlights                                  │
│ jk / kj         │ Exit insert mode (alternative to Esc)                    │
└─────────────────┴──────────────────────────────────────────────────────────┘

--]]
