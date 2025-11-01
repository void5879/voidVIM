--[[
================================================================================
                        MINI.NVIM MODULES CONFIGURATION
================================================================================

This file configures several modules from the `mini.nvim` suite, which provides
a collection of lightweight, fast, and cohesive Lua-based plugins.

MODULES CONFIGURED IN THIS FILE:
- `mini.comment`: Smart and context-aware commenting.
- `mini.files`: A minimal, fast file explorer.
- `mini.surround`: Add, delete, and replace surroundings (quotes, brackets).
- `mini.splitjoin`: Split and join code blocks (args, tables).

LOADING STRATEGY:
- `mini.nvim` itself is loaded as the base.
- Each module is configured as a separate plugin, often with lazy-loading
  events or keymaps to ensure they only load when needed.
================================================================================
--]]

return {
	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                       1. MINI.NVIM (BASE PLUGIN)                        │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		-- The base plugin for the 'mini' suite
		"echasnovski/mini.nvim",
		version = false, -- Use latest version from `main` branch
	},

	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                       2. MINI.COMMENT (COMMENTING)                      │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		"echasnovski/mini.comment",
		event = { "BufReadPost", "BufNewFile" },
		version = false,
		dependencies = {
			-- Required for context-aware commenting in JSX/TSX, Svelte, etc.
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			-- Disable the autocommand from ts-context-commentstring
			-- We will let mini.comment call it manually
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})

			-- Configure mini.comment
			require("mini.comment").setup({
				options = {
					-- This is the magic!
					-- It tells mini.comment to ask ts-context-commentstring
					-- for the correct comment string based on the cursor's
					-- Treesitter context (e.g., in HTML vs. JS block in Svelte)
					custom_commentstring = function()
						return require("ts_context_commentstring.internal").calculate_commentstring({
							key = "commentstring",
						}) or vim.bo.commentstring
					end,
				},
			})
		end,
	},

	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                       3. MINI.FILES (FILE EXPLORER)                     │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		"echasnovski/mini.files",
		-- Load this plugin when its keymaps are pressed
		keys = {
			{ "<leader>ee", "<cmd>lua MiniFiles.open()<CR>", desc = "Toggle mini.files explorer" },
			{
				"<leader>ef",
				function()
					-- This function opens mini.files and reveals the
					-- directory of the currently active buffer
					local MiniFiles = require("mini.files")
					MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
					MiniFiles.reveal_cwd()
				end,
				{ desc = "mini.files: Open at current file" },
			},
		},
		config = function()
			local MiniFiles = require("mini.files")
			MiniFiles.setup({
				-- Customize navigation mappings
				mappings = {
					go_in = "<CR>", -- Enter directory / open file
					go_in_plus = "L", -- (L) also enters/opens
					go_out = "-", -- Go up one directory
					go_out_plus = "H", -- (H) also goes up
				},
			})
		end,
	},

	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                       4. MINI.SURROUND (SURROUNDING)                    │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		"echasnovski/mini.surround",
		event = { "BufReadPost", "BufNewFile" },
		-- `opts` will be passed directly to the plugin's `setup` function
		opts = {
			-- Define mappings for surround actions
			mappings = {
				add = "sa", -- Add surrounding (Normal/Visual)
				delete = "ds", -- Delete surrounding
				find = "sf", -- Find surrounding (right)
				find_left = "sF", -- Find surrounding (left)
				highlight = "sh", -- Highlight surrounding
				replace = "sr", -- Replace surrounding
				update_n_lines = "sn", -- Not commonly used

				-- Suffixes for search
				suffix_last = "l",
				suffix_next = "n",
			},
			n_lines = 20, -- How many lines to search for surroundings
			silent = false, -- Show feedback (e.g., "Deleted '...")
			search_method = "cover", -- How to find surroundings
		},
	},

	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                     5. MINI.SPLITJOIN (SPLIT/JOIN)                      │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		"echasnovski/mini.splitjoin",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local miniSplitJoin = require("mini.splitjoin")
			miniSplitJoin.setup({
				-- Disable the default 'gS' mapping to avoid conflicts
				mappings = { toggle = "" },
			})

			-- Create custom keymaps for splitting and joining
			vim.keymap.set({ "n", "x" }, "sj", function()
				miniSplitJoin.join()
			end, { desc = "mini.splitjoin: Join" })

			vim.keymap.set({ "n", "x" }, "sk", function()
				miniSplitJoin.split()
			end, { desc = "mini.splitjoin: Split" })
		end,
	},
}

--[[
================================================================================
                              KEYMAPS REFERENCE
================================================================================

This table shows the *primary* keymaps for the configured modules.
`mini.comment` uses standard operator motions (e.g., `gc` or `gcc`).

┌─────────────────┬─────────────────┬─────────────────────────────────────────────────┐
│ Module          │ Key Combination │ Action                                          │
├─────────────────┼─────────────────┼─────────────────────────────────────────────────┤
│ mini.comment    │ gc              │ (Default) Toggle comment (e.g., `gcc` for line) │
├─────────────────┼─────────────────┼─────────────────────────────────────────────────┤
│ mini.files      │ <leader>ee      │ Toggle the file explorer                        │
│                 │ <leader>ef      │ Open explorer at the current file's location    │
├─────────────────┼─────────────────┼─────────────────────────────────────────────────┤
│ mini.surround   │ sa              │ Add surrounding (e.g., `sa"w` = "word")         │
│                 │ ds              │ Delete surrounding (e.g., `ds"` = delete ")     │
│                 │ sr              │ Replace surrounding (e.g., `sr"'` = " to ')     │
├─────────────────┼─────────────────┼─────────────────────────────────────────────────┤
│ mini.splitjoin  │ sj              │ Join code block (e.g., multi-line table to one) │
│                 │ sk              │ Split code block (e.g., one-line args to many)  │
└─────────────────┴─────────────────┴─────────────────────────────────────────────────┘

================================================================================
                              BEHAVIOR GUIDE
================================================================================

-   **Commenting (`mini.comment`)**:
    Press `gcc` to toggle the current line's comment.
    In a JSX file, it will correctly use `{/* ... */}` in the JS part and
    `` in the HTML part, thanks to `ts-context-commentstring`.

-   **File Explorer (`mini.files`)**:
    Press `<leader>ee` to open a minimal file tree.
    Use `<CR>` or `L` to enter directories/open files.
    Use `-` or `H` to go up a directory.

-   **Surrounding (`mini.surround`)**:
    With text `hello`, select it visually and type `sa(` to get `(hello)`.
    With cursor on `"world"`, type `ds"` to get `world`.
    With cursor on `'text'`, type `sr'"''` to get `"text"`.

-   **Split/Join (`mini.splitjoin`)**:
    On a line `local table = { a, b, c }`, press `sk` to split it:
    `local table = {
        a,
        b,
        c,
    }`
    Press `sj` on the `local table` line to join it back.

================================================================================
--]]
