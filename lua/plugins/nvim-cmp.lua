--[[
================================================================================
                        NVIM-CMP (COMPLETION) CONFIGURATION
================================================================================

This file configures `nvim-cmp`, the primary auto-completion framework for
Neovim. It's a complex setup that integrates multiple sources (LSP, snippets,
buffer) and customizes the UI (icons, formatting) and behavior (keymaps).

WHAT NVIM-CMP DOES:
- Provides an auto-completion menu as you type.
- Gathers completion "sources" from different plugins.
- Integrates with a snippet engine (`luasnip`) for smart snippets.
- Provides a rich UI with icons (`lspkind`) and custom formatting.
- Uses highly customized keymaps for navigation and confirmation.

KEY FEATURES OF THIS CONFIG:
- **Smart Keymaps:** <Tab> and <S-Tab> are context-aware. They navigate the
  menu, jump in snippets, insert smart indentation, or trigger completion.
- **Smart Confirmation:** The <CR> keymap uses custom logic to choose between
  "Insert" and "Replace" behavior to avoid overwriting text.
- **Custom UI:** Uses `lspkind` and a custom icon map for a rich,
  VS Code-like appearance in the completion menu.
- **Source-Aware:** Provides spell-checking completions *only* in markdown/text.

LOADING STRATEGY:
- Loads as soon as you enter Insert mode (`InsertEnter`), which is a
  good balance between startup speed and responsiveness.
================================================================================
--]]

return {
	"hrsh7th/nvim-cmp",
	-- Load the plugin when you enter insert mode
	event = "InsertEnter",
	-- Pinning to the main branch (as per your comment)
	branch = "main",

	-- ═══════════════════════════════════════════════════════════════════════
	--                              DEPENDENCIES
	-- ═══════════════════════════════════════════════════════════════════
	dependencies = {
		-- Completion Sources
		"hrsh7th/cmp-buffer", -- Source: text from the current buffer
		"hrsh7th/cmp-path", -- Source: file system paths
		"f3fora/cmp-spell", -- Source: spelling suggestions

		-- Snippet Engine
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*", -- Pin to major version 2
			-- Build step for regex-based snippets
			build = "make install_jsregexp",
		},
		"saadparwaiz1/cmp_luasnip", -- Integrates LuaSnip with nvim-cmp
		"rafamadriz/friendly-snippets", -- A large library of snippets

		-- Dependencies for UI & Context
		"nvim-treesitter/nvim-treesitter", -- Required for context-aware features
		"onsails/lspkind.nvim", -- Adds VS Code-style icons
		"roobert/tailwindcss-colorizer-cmp.nvim", -- Adds Tailwind color swatches
	},

	-- ═══════════════════════════════════════════════════════════════════════
	--                              MAIN CONFIGURATION
	-- ═══════════════════════════════════════════════════════════════════
	config = function()
		local cmp = require("cmp")
		-- Safely require LuaSnip, checking if it's available
		local has_luasnip, luasnip = pcall(require, "luasnip")
		local lspkind = require("lspkind")
		local colorizer = require("tailwindcss-colorizer-cmp").formatter

		-- ═════════════════════════════════════════════════════════════════
		--                  CUSTOM HELPER FUNCTIONS
		-- ═════════════════════════════════════════════════════════════════

		-- Helper to properly format keycodes for nvim_feedkeys
		local rhs = function(keys)
			return vim.api.nvim_replace_termcodes(keys, true, true, true)
		end

		-- Custom icon map for completion kinds
		-- This maps the LSP "kind" to a Nerd Font icon
		local lsp_kinds = {
			Class = " ",
			Color = " ",
			Constant = " ",
			Constructor = " ",
			Enum = " ",
			EnumMember = " ",
			Event = " ",
			Field = " ",
			File = " ",
			Folder = " ",
			Function = " ",
			Interface = " ",
			Keyword = " ",
			Method = " ",
			Module = " ",
			Operator = " ",
			Property = " ",
			Reference = " ",
			Snippet = " ",
			Struct = " ",
			Text = " ",
			TypeParameter = " ",
			Unit = " ",
			Value = " ",
			Variable = " ",
		}

		-- Helper function: Returns the current column number
		local column = function()
			local _line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col
		end

		-- Helper function: Checks if the cursor is inside an active snippet
		local in_snippet = function()
			if not has_luasnip then
				return false
			end
			local session = require("luasnip.session")
			local node = session.current_nodes[vim.api.nvim_get_current_buf()]
			if not node then
				return false
			end
			local snippet = node.parent.snippet
			local snip_begin_pos, snip_end_pos = snippet.mark:pos_begin_end()
			local pos = vim.api.nvim_win_get_cursor(0)
			if pos[1] - 1 >= snip_begin_pos[1] and pos[1] - 1 <= snip_end_pos[1] then
				return true
			end
		end

		-- Helper function: Checks if cursor is at start of line or on whitespace
		local in_whitespace = function()
			local col = column()
			return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match("%s")
		end

		-- Helper function: Checks if cursor is only on leading indentation
		local in_leading_indent = function()
			local col = column()
			local line = vim.api.nvim_get_current_line()
			local prefix = line:sub(1, col)
			return prefix:find("^%s*$")
		end

		-- Helper function: Gets the configured shift width
		local shift_width = function()
			if vim.o.softtabstop <= 0 then
				return vim.fn.shiftwidth()
			else
				return vim.o.softtabstop
			end
		end

		-- Smart Backspace logic
		local smart_bs = function(dedent)
			local keys = nil
			if vim.o.expandtab then
				if dedent then
					keys = rhs("<C-D>")
				else
					keys = rhs("<BS>")
				end
			else
				local col = column()
				local line = vim.api.nvim_get_current_line()
				local prefix = line:sub(1, col)
				if in_leading_indent() then
					keys = rhs("<BS>")
				else
					local previous_char = prefix:sub(#prefix, #prefix)
					if previous_char ~= " " then
						keys = rhs("<BS>")
					else
						keys = rhs("<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>")
					end
				end
			end
			vim.api.nvim_feedkeys(keys, "nt", true)
		end

		-- Smart Tab logic
		local smart_tab = function(opts)
			local keys = nil
			if vim.o.expandtab then
				keys = "<Tab>" -- Neovim will insert spaces.
			else
				local col = column()
				local line = vim.api.nvim_get_current_line()
				local prefix = line:sub(1, col)
				local in_leading_indent = prefix:find("^%s*$")
				if in_leading_indent then
					-- inserts a hard tab.
					keys = "<Tab>"
				else
					local sw = shift_width()
					local previous_char = prefix:sub(#prefix, #prefix)
					local previous_column = #prefix - #previous_char + 1
					local current_column = vim.fn.virtcol({ vim.fn.line("."), previous_column }) + 1
					local remainder = (current_column - 1) % sw
					local move = remainder == 0 and sw or sw - remainder
					keys = (" "):rep(move)
				end
			end
			vim.api.nvim_feedkeys(rhs(keys), "nt", true)
		end

		-- Helper: Selects next item, or calls fallback if menu isn't visible
		local select_next_item = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end

		-- Helper: Selects previous item, or calls fallback
		local select_prev_item = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end

		-- confirmation logic:
		-- This function intelligently decides whether to "Insert" or "Replace"
		-- a completion item to prevent overwriting text you've already typed
		-- after the cursor.
		local confirm = function(entry)
			local behavior = cmp.ConfirmBehavior.Replace
			if entry then
				local completion_item = entry.completion_item
				local newText = ""
				if completion_item.textEdit then
					newText = completion_item.textEdit.newText
				elseif type(completion_item.insertText) == "string" and completion_item.insertText ~= "" then
					newText = completion_item.insertText
				else
					newText = completion_item.word or completion_item.label or ""
				end

				-- checks how many characters will be different after the cursor position if we replace?
				local diff_after = math.max(0, entry.replace_range["end"].character + 1) - entry.context.cursor.col

				-- does the text that will be replaced after the cursor match the suffix
				-- of the `newText` to be inserted ? if not, then `Insert` instead.
				if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
					behavior = cmp.ConfirmBehavior.Insert
				end
			end
			cmp.confirm({ select = true, behavior = behavior })
		end

		-- ═════════════════════════════════════════════════════════════════
		--                        SNIPPET LOADING
		-- ═════════════════════════════════════════════════════════════════

		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()

		-- ═════════════════════════════════════════════════════════════════
		--                        CMP MAIN SETUP
		-- ═════════════════════════════════════════════════════════════════

		cmp.setup({
			experimental = {
				-- Ghost text shows the top completion inline, like Copilot
				-- It is disabled here, but the experimental logic is below.
				ghost_text = false,
			},
			completion = {
				-- `noinsert` means completion won't be auto-inserted
				completeopt = "menu,menuone,noinsert",
			},
			-- Configure the borders of the completion and documentation windows
			window = {
				documentation = {
					border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
				},
				completion = {
					border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
				},
			},
			-- Tell nvim-cmp to use LuaSnip as its snippet engine
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			-- ═════════════════════════════════════════════════════════════
			--                        COMPLETION SOURCES
			-- ═════════════════════════════════════════════════════════════
			-- Sources are listed in priority order
			sources = cmp.config.sources({
				{ name = "luasnip" }, -- 1. Snippets
				{ name = "lazydev" }, -- 2. Lua (for Neovim config)
				{ name = "nvim_lsp" }, -- 3. Language Server Protocol
				{ name = "buffer" }, -- 4. Current buffer
				{ name = "path" }, -- 5. File paths
				{ name = "tailwindcss-colorizer-cmp" }, -- 6. Tailwind colors
				{
					name = "spell", -- 7. Spell checking
					option = {
						-- Only enable spell source for markdown and text
						enable_in_context = function()
							local ft = vim.bo.filetype
							return ft == "markdown" or ft == "text"
						end,
					},
				},
			}),

			-- (This is your original, simpler mapping, kept for reference)
			-- mapping = cmp.mapping.preset.insert({
			--     ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
			--     ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
			--     ["<C-b>"] = cmp.mapping.scroll_docs(-4),
			--     ["<C-f>"] = cmp.mapping.scroll_docs(4),
			--     ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
			--     ["<C-e>"] = cmp.mapping.abort(), -- close completion window
			--     ["<CR>"] = cmp.mapping.confirm({ select = false }),
			-- }),

			-- ═════════════════════════════════════════════════════════════
			--                     CUSTOM KEYMAPPINGS
			-- ═════════════════════════════════════════════════════════════
			-- This is your advanced, context-aware keymapping setup
			mapping = cmp.mapping.preset.insert({
				-- Close completion/docs
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<C-d>"] = cmp.mapping(function()
					cmp.close_docs()
				end, { "i", "s" }),

				-- Scroll documentation
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),

				-- Navigation
				["<C-j>"] = cmp.mapping(select_next_item),
				["<C-k>"] = cmp.mapping(select_prev_item),
				["<C-n>"] = cmp.mapping(select_next_item),
				["<C-p>"] = cmp.mapping(select_prev_item),
				["<Down>"] = cmp.mapping(select_next_item),
				["<Up>"] = cmp.mapping(select_prev_item),

				-- Confirmation (uses your smart 'confirm' function)
				["<C-y>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						local entry = cmp.get_selected_entry()
						confirm(entry)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<CR>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						local entry = cmp.get_selected_entry()
						confirm(entry)
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Smart Shift-Tab (Back-Tab)
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item() -- 1. Menu is open: Go up
					elseif has_luasnip and in_snippet() and luasnip.jumpable(-1) then
						luasnip.jump(-1) -- 2. In snippet: Jump back
					elseif in_leading_indent() then
						smart_bs(true) -- 3. In indent: Dedent
					elseif in_whitespace() then
						smart_bs() -- 4. In whitespace: Normal backspace
					else
						fallback() -- 5. Otherwise: Fallback
					end
				end, { "i", "s" }),

				-- Smart Tab
				["<Tab>"] = cmp.mapping(function(_fallback)
					if cmp.visible() then
						-- 1. Menu is open
						local entries = cmp.get_entries()
						if #entries == 1 then
							confirm(entries[1]) -- Confirm if only one item
						else
							cmp.select_next_item() -- Go to next item
						end
					elseif has_luasnip and luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump() -- 2. In snippet: Expand/jump
					elseif in_whitespace() then
						smart_tab() -- 3. In whitespace: Insert smart tab
					else
						cmp.complete() -- 4. Otherwise: Open completion
					end
				end, { "i", "s" }),
			}),

			-- ═════════════════════════════════════════════════════════════
			--                        UI FORMATTING
			-- ═════════════════════════════════════════════════════════════
			-- This function builds the appearance of each item in the menu
			formatting = {
				format = function(entry, vim_item)
					-- 1. Add custom icons from your `lsp_kinds` table
					vim_item.kind = string.format("%s %s", lsp_kinds[vim_item.kind] or "", vim_item.kind)

					-- 2. Add source menu (e.g., [Buffer], [LSP])
					vim_item.menu = ({
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						luasnip = "[LuaSnip]",
						nvim_lua = "[Lua]",
						latex_symbols = "[LaTeX]",
					})[entry.source.name]

					-- 3. Apply `lspkind` formatting (icons, maxwidth, ellipsis)
					vim_item = lspkind.cmp_format({
						maxwidth = 25,
						ellipsis_char = "...",
					})(entry, vim_item)

					-- 4. Apply `tailwindcss-colorizer` if it's an LSP item
					if entry.source.name == "nvim_lsp" then
						vim_item = colorizer(entry, vim_item)
					end

					return vim_item
				end,

				-- (Your original, simpler formatting options, kept for reference)
				-- format = lspkind.cmp_format({
				--         maxwidth = 30,
				--         ellipsis_char = "...",
				--         before = require("tailwindcss-colorizer-cmp").formatter
				-- }),
				-- format = require("tailwindcss-colorizer-cmp").formatter
			},
		})

		-- ═════════════════════════════════════════════════════════════════
		--              GHOST TEXT (EXPERIMENTAL - COMMENTED OUT)
		-- ═════════════════════════════════════════════════════════════════
		-- This is your commented-out logic for experimental ghost text.
		-- It tries to show ghost text only at word boundaries.

		-- local config = require('cmp.config')
		-- local toggle_ghost_text = function()
		--     if vim.api.nvim_get_mode().mode ~= 'i' then
		--         return
		--     end
		--
		--     local cursor_column = vim.fn.col('.')
		--     local current_line_contents = vim.fn.getline('.')
		--     local character_after_cursor = current_line_contents:sub(cursor_column, cursor_column)
		--
		--     local should_enable_ghost_text = character_after_cursor == '' or vim.fn.match(character_after_cursor, [[\k]]) == -1
		--
		--     local current = config.get().experimental.ghost_text
		--     if current ~= should_enable_ghost_text then
		--         config.set_global({
		--             experimental = {
		--                 ghost_text = should_enable_ghost_text,
		--             },
		--         })
		--     end
		-- end
		--
		-- vim.api.nvim_create_autocmd({ 'InsertEnter', 'CursorMovedI' }, {
		--     callback = toggle_ghost_text,
		-- })
	end,
}

--[[
================================================================================
                              KEYMAPS REFERENCE (INSERT MODE)
================================================================================

This is a complex, context-aware mapping system.

┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <Tab>           │ 1. If menu open: Select next item (or confirm if 1 left) │
│                 │ 2. If in snippet: Expand or jump to next placeholder     │
│                 │ 3. If in whitespace: Insert a "smart tab"                │
│                 │ 4. Otherwise: Open completion menu                       │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <S-Tab>         │ 1. If menu open: Select previous item                    │
│                 │ 2. If in snippet: Jump to previous placeholder           │
│                 │ 3. If in leading indent: Dedent (outdent)                │
│                 │ 4. Otherwise: Normal backspace                           │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <CR> / <C-y>    │ Confirm the selected completion using your custom smart  │
│                 │ logic (chooses between Insert and Replace)               │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <C-j> / <C-k>   │ Navigate up and down the completion menu                 │
│ <C-n> / <C-p>   │                                                          │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <C-e>           │ Abort (close) the completion menu                        │
│ <C-d>           │ Close the documentation window                           │
│ <C-f> / <C-b>   │ Scroll the documentation window                          │
└─────────────────┴──────────────────────────────────────────────────────────┘

================================================================================
                              COMPLETION SOURCES
================================================================================

Completions are gathered from these sources, in order of priority:

1.  **LuaSnip**: Code snippets (e.g., `for` loops, function templates).
2.  **lazydev**: Completions for writing your Neovim config in Lua.
3.  **nvim_lsp**: Context-aware code completions from your Language Server.
4.  **buffer**: Text that already exists in your current file.
5.  **path**: File system paths (e.g., `~/Projects/`).
6.  **tailwindcss-colorizer-cmp**: Tailwind class names.
7.  **spell**: Spelling suggestions (in Markdown/Text files).

================================================================================
                              UI & FORMATTING
================================================================================

The completion menu is formatted to show:
-   **Icons**: A custom set of Nerd Font icons (`lsp_kinds`).
-   **Source**: A tag showing where the completion came from (`[LSP]`, `[Buffer]`).
-   **LSPKind Icons**: Default `lspkind` icons as a fallback.
-   **Tailwind Colors**: A color swatch next to Tailwind color classes.

================================================================================
--]]
