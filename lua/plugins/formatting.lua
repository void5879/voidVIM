--[[
================================================================================
                        CONFORM.NVIM FORMATTING CONFIGURATION
================================================================================

Conform.nvim is a high-performance, opinionated formatting plugin for Neovim.
It manages and runs various code formatters (like Prettier, Black, Stylua)
and is designed to be lightweight and fast.

WHAT CONFORM DOES:
- Provides a single interface for all code formatters.
- Can run formatters asynchronously on save.
- Allows for complex formatter setups, including conditional formatters
  and fallbacks.
- Replaces heavier plugins like `null-ls` for formatting.

LOADING STRATEGY:
- Loads lazily on file open events for a faster startup.
- Configured to format on save.
================================================================================
--]]

return {
	-- The main formatting plugin
	"stevearc/conform.nvim",

	-- ═══════════════════════════════════════════════════════════════════
	--                              LOADING STRATEGY
	-- ═══════════════════════════════════════════════════════════════════

	event = { "BufReadPre", "BufNewFile" },

	-- ═══════════════════════════════════════════════════════════════════
	--                              MAIN CONFIGURATION
	-- ═══════════════════════════════════════════════════════════════════

	config = function()
		local conform = require("conform")

		-- Configure conform's main setup
		conform.setup({
			-- ═════════════════════════════════════════════════════════════
			--                 CONDITIONAL/SPECIAL FORMATTERS
			-- ═════════════════════════════════════════════════════════════
			-- These formatters have special conditions to run
			formatters = {
				-- Only run `markdown-toc` if the file contains the 'toc' comment
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				-- Only run `markdownlint-cli2` if there are existing linter issues
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
			},

			-- ═════════════════════════════════════════════════════════════
			--                   FORMATTERS BY FILE TYPE
			-- ═════════════════════════════════════════════════════════════
			-- Map filetypes to their desired formatters
			-- Formatters run in the order they are listed.
			formatters_by_ft = {
				-- Web
				javascript = { "biome-check" },
				typescript = { "biome-check" },
				javascriptreact = { "biome-check" },
				typescriptreact = { "biome-check" },
				css = { "biome-check" },
				html = { "biome-check" },
				json = { "prettier" },
				-- Svelte/YAML/GraphQL use Prettier
				svelte = { "prettier" },
				yaml = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				-- Lua
				lua = { "stylua" },
				-- Python
				python = { "black", "isort" }, -- Run black first, then isort
				-- C/C++
				c = { "clang-format" },
				cpp = { "clang-format" },
				-- Markdown
				markdown = { "prettier", "markdown-toc" },
				-- java = { "google-java-format" }, -- Example: commented out
			},

			-- ═════════════════════════════════════════════════════════════
			--                        FORMAT ON SAVE
			-- ═════════════════════════════════════════════════════════════
			format_on_save = {
				-- If conform's formatters fail, fallback to the LSP formatter
				lsp_fallback = true,
				-- Run synchronously. Set to `true` for async
				async = false,
				-- Timeout for formatting, in milliseconds
				timeout_ms = 1000,
			},
		})

		-- ═════════════════════════════════════════════════════════════════
		--                 INDIVIDUAL FORMATTER OVERRIDES
		-- ═════════════════════════════════════════════════════════════════

		-- Override default args for 'prettier'
		conform.formatters.prettier = {
			args = {
				"--stdin-filepath",
				"$FILENAME", -- Tell prettier the file's name
				"--tab-width",
				"4", -- Use 4 spaces for tabs
				"--use-tabs",
				"false", -- Use spaces, not tabs
			},
		}

		-- Override default args for 'shfmt'
		conform.formatters.shfmt = {
			prepend_args = { "-i", "4" }, -- Indent with 4 spaces
		}

		-- ═════════════════════════════════════════════════════════════════
		--                            KEYMAP
		-- ═════════════════════════════════════════════════════════════════
		-- Manual format command for Normal and Visual modes
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format [M]anually with [P]rettier/Conform" })
	end,
}

--[[
================================================================================
                              QUICK REFERENCE
================================================================================

-   **On Save**: This plugin is configured to format automatically on save.
-   **Manual Format**: Press `<leader>mp` in Normal or Visual mode to format.
-   **LSP Fallback**: If `biome-check` or `prettier` fails, it will try to use
    your attached Language Server (LSP) to format instead.

FORMATTER ASSIGNMENTS:
┌───────────────────┬──────────────────────────────────────────────────────────┐
│ Filetype(s)       │ Formatter(s)                                             │
├───────────────────┼──────────────────────────────────────────────────────────┤
│ JS, TS, React, CSS│ biome-check                                              │
│ HTML, JSON, Svelte│ prettier                                                 │
│ YAML, GraphQL     │                                                          │
│ Lua               │ stylua                                                   │
│ Python            │ black (code) -> isort (imports)                          │
│ C, C++            │ clang-format                                             │
│ Markdown          │ prettier (text) -> markdown-toc (table of contents)      │
└───────────────────┴──────────────────────────────────────────────────────────┘

================================================================================
--]]
