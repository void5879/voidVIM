--[[
================================================================================
                        RUST DEVELOPMENT CONFIGURATION
================================================================================

This file configures the complete Rust development environment, including
the language server (rust-analyzer), debugging, and dependency management
for `Cargo.toml`.

PLUGINS IN THIS FILE:
1. `rustaceanvim`: The all-in-one plugin for Rust. It manages `rust-analyzer`
   and integrates debugging (`DAP`) using `codelldb`.
2. `rust.vim`: The classic Vim plugin for Rust, used here for its auto-formatting
   on save feature with `rustfmt`.
3. `crates.nvim`: A helper plugin to manage dependencies inside `Cargo.toml`
   files, providing auto-completion for crate names and versions.
================================================================================
--]]
return {
	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                        1. RUSTACEANVIM (LSP + DAP)                      │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
		ft = "rust",
		-- ═══════════════════════════════════════════════════════════════════
		--                              MAIN CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════
		config = function()
			-- Paths for the CodeLLDB debugger, which must be installed via Mason
			local extension_path = "~/.local/share/nvim/mason/packages/codelldb/extension/"
			local codelldb_path = extension_path .. "adapter/codelldb"
			local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
			-- Get the rustaceanvim config helper
			local cfg = require("rustaceanvim.config")
			-- Set up the global configuration for rustaceanvim
			vim.g.rustaceanvim = {
				-- Configure the Debug Adapter Protocol (DAP)
				dap = {
					-- Use the `get_codelldb_adapter` helper to configure
					-- the debugger paths automatically.
					adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
				},
			}
		end,
	},
	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                       2. RUST.VIM (FORMATTING)                          │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		"rust-lang/rust.vim",
		ft = "rust",
		-- `init` runs *before* the plugin loads
		init = function()
			-- Enable auto-formatting with `rustfmt` on every save
			vim.g.rustfmt_autosave = 1
		end,
	},
	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                      3. CRATES.NVIM (TOML HELPER)                       │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		"saecki/crates.nvim",
		-- Load only for TOML files (specifically `Cargo.toml`)
		ft = { "toml" },
		dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
		-- ═══════════════════════════════════════════════════════════════════
		--                              MAIN CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════
		config = function()
			local crates = require("crates")

			crates.setup({
				lsp = {
					enabled = true, -- enable the in-process LSP
					completion = true, -- must be boolean now
				},
			})

			-- ═════════════════════════════════════════════════════════════
			--                     NVIM-CMP INTEGRATION
			-- ═════════════════════════════════════════════════════════════
			-- Configure nvim-cmp to use the `crates.nvim` LSP source
			-- specifically for `toml` files.
			local cmp = require("cmp")
			cmp.setup.filetype("toml", {
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- use LSP source (includes crates)
				}),
			})
		end,
	},
}
--[[
================================================================================
                              QUICK REFERENCE
================================================================================

This setup provides a full Rust IDE experience:

1.  **Code Editing & LSP (`rustaceanvim`)**:
    * Manages `rust-analyzer` for you.
    * Provides diagnostics, hover info, go-to-definition, etc.

2.  **Debugging (`rustaceanvim` + `codelldb`)**:
    * Integrates `codelldb` for a full debugging experience.
    * Use your `nvim-dap` keymaps (e.g., setting breakpoints, stepping).

3.  **Formatting (`rust.vim`)**:
    * Automatically runs `rustfmt` every time you save a `.rs` file.

4.  **Dependency Management (`crates.nvim`)**:
    * When editing `Cargo.toml`, you'll get auto-completion for:
        * Crate names (e.g., typing `ser` suggests `serde`).
        * Crate versions (e.g., `serde = "..."` will suggest versions).
        * Features and keywords.

================================================================================
--]]
