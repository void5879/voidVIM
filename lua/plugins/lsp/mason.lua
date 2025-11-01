--[[
================================================================================
                        MASON (PACKAGE MANAGER) CONFIGURATION
================================================================================

This file configures `mason.nvim`, `mason-lspconfig.nvim`, and
`mason-tool-installer.nvim`. This suite of plugins handles the installation
and management of external tools like Language Servers, Linters, and Formatters.

WHAT THESE PLUGINS DO:
- `mason.nvim`: The core plugin. A package manager that lets you easily
  install/uninstall binaries from a large registry. Provides the `:Mason` UI.
- `mason-lspconfig.nvim`: A bridge plugin. It connects Mason to `nvim-lspconfig`,
  making it easy to install LSPs listed in your `lsp-config.lua`.
- `mason-tool-installer.nvim`: An extension plugin. It automatically installs
  non-LSP tools (like formatters and linters) from a list.

REPLACES:
- Manually downloading and managing binaries for LSPs, formatters, and linters.
================================================================================
--]]

return {
	"williamboman/mason.nvim",
	-- Load lazily when a file is opened
	event = { "BufReadPost", "BufNewFile" },
	-- lazy = false, -- Kept your commented-out line

	-- ═══════════════════════════════════════════════════════════════════════
	--                              DEPENDENCIES
	-- ═══════════════════════════════════════════════════════════════════════
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp", -- For LSP capabilities
		"neovim/nvim-lspconfig", -- To configure the LSPs
		-- "saghen/blink.cmp",
	},

	-- ═══════════════════════════════════════════════════════════════════════
	--                              MAIN CONFIGURATION
	-- ═══════════════════════════════════════════════════════════════════════
	config = function()
		-- import mason and its helper plugins
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- ═════════════════════════════════════════════════════════════════
		--                        1. MASON (CORE)
		-- ═════════════════════════════════════════════════════════════════
		-- enable mason and configure UI icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- ═════════════════════════════════════════════════════════════════
		--                    2. MASON-LSPCONFIG (LSP BRIDGE)
		-- ═════════════════════════════════════════════════════════════════
		mason_lspconfig.setup({
			-- This plugin *installs* LSPs, but it does NOT *start* them.
			-- Setting this to `false` lets `lsp-config.lua` handle starting.
			automatic_enable = false,

			-- List of LSP servers for Mason to automatically install
			ensure_installed = {
				"lua_ls",
				"ts_ls", -- currently using a ts plugin
				"html",
				"cssls",
				"tailwindcss",
				-- "gopls",
				-- "angularls",
				"emmet_ls",
				"emmet_language_server",
				-- "eslint",
				"marksman", -- For Markdown
				"pyright", -- For Python
				"clangd", -- For C/C++
				"rust_analyzer", -- For Rust
			},
		})

		-- ═════════════════════════════════════════════════════════════════
		--                  3. MASON-TOOL-INSTALLER (TOOLS)
		-- ═════════════════════════════════════════════════════════════════
		mason_tool_installer.setup({
			-- List of non-LSP tools (formatters, linters) to install
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python import formatter
				"pylint", -- python linter
				"clang-format", -- c/c++ formatter
				-- "eslint_d",
				-- "denols",
				-- { 'eslint_d', version = '13.1.2' },
			},
		})
	end,
}

--[[
================================================================================
                              QUICK REFERENCE
================================================================================

BEHAVIOR:
- On startup (after a file loads), Mason checks the `ensure_installed` lists.
- Any missing LSPs (from `mason-lspconfig`) or Tools (from
  `mason-tool-installer`) will be automatically downloaded and installed.
- This file **DOES NOT** start or configure the LSPs. It only *installs* them.
  The actual configuration happens in `lsp-config.lua`.

INSTALLED TOOLS:
┌──────────────────────────┬──────────────────────────────────────────────────┐
│ Category                 │ Tools Automatically Installed                    │
├──────────────────────────┼──────────────────────────────────────────────────┤
│ LSPs                     │ lua_ls, ts_ls, html, cssls, tailwindcss,         │
│ (via mason-lspconfig)    │ emmet_ls, emmet_language_server, marksman,       │
│                          │ pyright, clangd                                  │
├──────────────────────────┼──────────────────────────────────────────────────┤
│ Formatters & Linters     │ prettier, stylua, isort, pylint, clang-format    │
│(via mason-tool-installer)│                                                  │
└──────────────────────────┴──────────────────────────────────────────────────┘

USEFUL MASON COMMANDS:
- `:Mason` : Opens the Mason UI to browse, install, or uninstall tools.
- `:MasonInstall <tool>` : Manually install a tool (e.g., `:MasonInstall shfmt`).
- `:MasonLog` : View the Mason log file for troubleshooting.

================================================================================
--]]
