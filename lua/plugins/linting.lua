--[[
================================================================================
                        NVIM-LINT (LINTING) CONFIGURATION
================================================================================

This file configures `nvim-lint`, an asynchronous linting plugin for Neovim.
It runs linters (like `biomejs`, `pylint`) in the background and uses Neovim's
built-in diagnostics to display errors and warnings.

WHAT LINTING DOES:
- Runs static code analysis tools (linters) on your code.
- Shows errors and warnings directly in the editor (in the gutter, as
  virtual text, and in the trouble list).
- Is configured to run automatically on file save and other events.

LOADING STRATEGY:
- Loads lazily when a file is opened.
- An autocommand group (`lint`) is created to trigger linting on
  `BufEnter`, `BufWritePost`, and `InsertLeave`.
================================================================================
--]]

return {
	-- The main linting plugin
	"mfussenegger/nvim-lint",

	-- ═══════════════════════════════════════════════════════════════════════
	--                              LOADING STRATEGY
	-- ═══════════════════════════════════════════════════════════════════

	event = { "BufReadPre", "BufNewFile" },

	-- ═══════════════════════════════════════════════════════════════════════
	--                              MAIN CONFIGURATION
	-- ═══════════════════════════════════════════════════════════════════

	config = function()
		local lint = require("lint")

		-- Create a dedicated autocommand group for linting
		-- `clear = true` ensures it doesn't get duplicated on reload
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- ═════════════════════════════════════════════════════════════════
		--                     LINTERS BY FILE TYPE
		-- ═════════════════════════════════════════════════════════════════
		-- Map filetypes to their corresponding linter executable
		-- These must be installed on your system (e.g., via Mason, npm, pip)
		lint.linters_by_ft = {
			lua = { "luacheck" },
			-- Using Biome for all web-related linting
			javascript = { "biomejs" },
			typescript = { "biomejs" },
			javascriptreact = { "biomejs" },
			typescriptreact = { "biomejs" },
			svelte = { "biomejs" },
			-- Python
			python = { "pylint" },
			-- C/C++
			c = { "cpplint" },
			cpp = { "cpplint" },
		}

		-- ═════════════════════════════════════════════════════════════════
		--                 INDIVIDUAL LINTER CONFIGURATION
		-- ═════════════════════════════════════════════════════════════════
		-- Example: Customize arguments for `eslint_d` (if it were used)
		-- This is kept as an example of how to configure a specific linter.
		local eslint = lint.linters.eslint_d
		eslint.args = {
			"--no-warn-ignored",
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
			function()
				return vim.fn.expand("%:p") -- Pass the full file path
			end,
		}

		-- ═════════════════════════════════════════════════════════════════
		--                       AUTOMATIC LINTING
		-- ═════════════════════════════════════════════════════════════════
		-- Automatically run the linter on specific events
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- `try_lint` will run the configured linter for the filetype
				lint.try_lint()
			end,
		})

		-- ═════════════════════════════════════════════════════════════════
		--                            KEYMAP
		-- ═════════════════════════════════════════════════════════════════
		-- Manually trigger a lint for the current file
		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Lint: Trigger lint for current file" })
	end,
}

--[[
================================================================================
                              QUICK REFERENCE
================================================================================

LINTING TRIGGERS:
┌───────────────────────────┬──────────────────────────────────────────────────┐
│ Trigger                   │ Description                                      │
├───────────────────────────┼──────────────────────────────────────────────────┤
│ `BufEnter`                │ Run linting when you open a buffer               │
│ `BufWritePost`            │ Run linting after you save a file                │
│ `InsertLeave`             │ Run linting when you exit Insert mode            │
│ `<leader>l`               │ Manually trigger linting                         │
└───────────────────────────┴──────────────────────────────────────────────────┘

LINTER ASSIGNMENTS:
┌───────────────────────────┬──────────────────────────────────────────────────┐
│ Filetype(s)               │ Linter                                           │
├───────────────────────────┼──────────────────────────────────────────────────┤
│ lua                       │ luacheck                                         │
│ js, ts, jsx, tsx, svelte  │ biomejs                                          │
│ python                    │ pylint                                           │
│ c, cpp                    │ cpplint                                          │
└───────────────────────────┴──────────────────────────────────────────────────┘

BEHAVIOR GUIDE:
-   Linting runs automatically when you save, open a file, or exit insert mode.
-   Errors and warnings will appear as icons in the sign column (gutter)
    and may be underlined.
-   You can manually re-trigger a lint at any time by pressing `<leader>l`.
-   Use `vim.diagnostic.open_float()` (or a keymap for it) to see error details.

================================================================================
--]]
