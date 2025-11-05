 --[[
================================================================================
                        LSPCONFIG (LANGUAGE SERVER) CONFIGURATION
================================================================================

This file configures `nvim-lspconfig`, the core Neovim plugin that
communicates with Language Servers.

WHAT LSPCONFIG DOES:
- Starts, stops, and configures the LSPs that `mason.nvim` installed.
- Defines keymaps that are only active when an LSP is running.
- Configures diagnostic (error/warning) signs and behavior.
- Sets "capabilities" (telling the server what Neovim supports).

KEY FEATURES OF THIS CONFIG:
- `LspAttach` Autocommand: The *most important* part. It sets buffer-local
  keymaps only when an LSP successfully attaches to a buffer.
- Custom Diagnostics: Uses Nerd Font icons for errors, warnings, etc.
- Smart `pyright` setup: Includes a helper function to automatically
  detect and use a Python virtual environment (`.venv`).
- Commented-out Keymaps: Your notes about `snacks.lua` handling picker-based
  keymaps are preserved.
================================================================================
--]]

return {
	{
		"neovim/nvim-lspconfig",
		-- Load lazily when a file is opened
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- For completion capabilities
			{ "antosha417/nvim-lsp-file-operations", config = true }, -- For file ops
		},
		config = function()
			-- ═════════════════════════════════════════════════════════════
			--                       LSP KEYMAPS (LspAttach)
			-- ═════════════════════════════════════════════════════════════
			-- We create an autocommand that runs *only* when an LSP
			-- successfully attaches to a buffer.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings
					local opts = { buffer = ev.buf, silent = true }

					-- ┌───────────────────────────────────────────────────────┐
					-- │    NOTE: Picker keymaps are defined in `snacks.lua`   │
					-- └───────────────────────────────────────────────────────┘
					-- opts.desc = "Show LSP references"
					-- vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
					-- opts.desc = "Go to declaration"
					-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					-- opts.desc = "Show LSP definitions"
					-- vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
					-- opts.desc = "Show LSP implementations"
					-- vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
					-- opts.desc = "Show LSP type definitions"
					-- vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
					-- opts.desc = "Show buffer diagnostics"
					-- vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

					-- ═════════════════════════════════════════════════════
					--                       ACTIVE KEYMAPS
					-- ═════════════════════════════════════════════════════
					opts.desc = "See available code actions"
					vim.keymap.set({ "n", "v" }, "<leader>vca", function()
						vim.lsp.buf.code_action()
					end, opts)

					opts.desc = "Smart rename"
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					opts.desc = "Show line diagnostics"
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

					opts.desc = "Show documentation for what is under cursor"
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

					opts.desc = "Restart LSP"
					vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

					opts.desc = "Signature help"
					vim.keymap.set("i", "<A-h>", vim.lsp.buf.signature_help, opts)
				end,
			})

			-- ═════════════════════════════════════════════════════════════
			--                     DIAGNOSTIC CONFIGURATION
			-- ═════════════════════════════════════════════════════════════

			-- Define sign icons for each severity
			local signs = {
				[vim.diagnostic.severity.ERROR] = " ", -- Error icon
				[vim.diagnostic.severity.WARN] = " ", -- Warning icon
				[vim.diagnostic.severity.HINT] = "󰠠 ", -- Hint icon
				[vim.diagnostic.severity.INFO] = " ", -- Info icon
			}

			-- Set diagnostic config
			vim.diagnostic.config({
				signs = {
					text = signs, -- Use our custom icons
				},
				virtual_text = true, -- Show errors inline
				underline = true, -- Underline errors
				update_in_insert = false, -- Don't update while typing
			})

			-- ═════════════════════════════════════════════════════════════
			--                LSP CAPABILITIES & GLOBAL SETUP
			-- ═════════════════════════════════════════════════════════════

			-- Setup servers
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			-- Get capabilities from `cmp-nvim-lsp` to enable autocompletion
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- Global LSP settings (applied to all servers)
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- ═════════════════════════════════════════════════════════════
			--                        SERVER CONFIGURATIONS
			-- ═════════════════════════════════════════════════════════════
			-- Configure and enable individual LSP servers
			-- These servers MUST be installed by Mason first.

			-- 1. LUA
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" }, -- Allow 'vim' global
						},
						completion = {
							callSnippet = "Replace",
						},
						workspace = {
							-- Tell lua_ls about our vim runtime and config paths
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")

			-- 2. EMMET (emmet_language_server)
			vim.lsp.config("emmet_language_server", {
				filetypes = {
					"css",
					"eruby",
					"html",
					"javascript",
					"javascriptreact",
					"less",
					"sass",
					"scss",
					"pug",
					"typescriptreact",
				},
				init_options = {
					-- (User's specific emmet options)
					includeLanguages = {},
					excludeLanguages = {},
					extensionsPath = {},
					preferences = {},
					showAbbreviationSuggestions = true,
					showExpandedAbbreviation = "always",
					showSuggestionsAsSnippets = false,
					syntaxProfiles = {},
					variables = {},
				},
			})
			vim.lsp.enable("emmet_language_server")

			-- 3. EMMET (emmet_ls)
			vim.lsp.config("emmet_ls", {
				filetypes = {
					"html",
					"typescriptreact",
					"javascriptreact",
					"css",
					"sass",
					"scss",
					"less",
					"svelte",
				},
			})
			vim.lsp.enable("emmet_ls")

			-- 4. TYPESCRIPT / JAVASCRIPT
			vim.lsp.config("ts_ls", {
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
				},
				single_file_support = true,
				init_options = {
					preferences = {
						includeCompletionsForModuleExports = true,
						includeCompletionsForImportStatements = true,
					},
				},
			})
			vim.lsp.enable("ts_ls")

			-- 5. PYTHON
			-- Helper function to find the correct python executable
			local function get_python_path()
				local venv = vim.fn.getcwd() .. "/.venv/bin/python"
				-- If a local .venv exists, use it
				if vim.fn.filereadable(venv) == 1 then
					return venv
				end
				-- Otherwise, fall back to system python
				return vim.fn.exepath("python3") or vim.fn.exepath("python")
			end

			vim.lsp.config("pyright", {
				filetypes = { "python" },
				settings = {
					python = {
						pythonPath = get_python_path(), -- Use our smart helper
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
							typeCheckingMode = "basic",
						},
					},
				},
			})
			vim.lsp.enable("pyright")

			-- 6. C / C++
			vim.lsp.config("clangd", {
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
				-- ┌───────────────────────────────────────────────────────────┐
				-- │ ⚠️  IMPORTANT CLANGD NOTE                                 │
				-- ├───────────────────────────────────────────────────────────┤
				-- │ For clangd to work effectively, it needs a                │
				-- │ `compile_commands.json` file in your project's root.      │
				-- │ You can generate this with build systems like CMake       │
				-- │ by adding `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`            │
				-- │ or by using a tool like `bear` (e.g., `bear -- make`).    │
				-- └───────────────────────────────────────────────────────────┘
			})
			vim.lsp.enable("clangd")

			-- 7. GO
			-- vim.lsp.config("gopls", {
			--   settings = {
			--     gopls = {
			--       analyses = {
			--           unusedparams = true,
			--       },
			--       staticcheck = true,
			--       gofumpt = true,
			--     },
			--   },
			-- })
			-- vim.lsp.enable("gopls")

			-- 8. Nix
			vim.lsp.config["nil_ls"] = {
				cmd = { "nil" },
				filetypes = { "nix" },
				root_markers = { "flake.nix", "default.nix", ".git" },
				capabilities = caps,
				settings = {
					["nil"] = {
						formatting = {
							command = { "nixpkgs-fmt" }, -- or "alejandra" if you prefer
						},
					},
				},
			}
			vim.lsp.enable("nil_ls")
		end,
	},
}

--[[
================================================================================
                              QUICK REFERENCE
================================================================================

BEHAVIOR:
- When you open a file (e.g., `.py`, `.js`), `lspconfig` finds the matching
  server (e.g., `pyright`, `ts_ls`) and starts it.
- Once the server is running, the `LspAttach` autocommand fires.
- This `LspAttach` event activates the buffer-local keymaps listed below.
- Diagnostics (errors, warnings) will appear in the gutter and as inline text.

ACTIVE KEYMAPS (ONLY IN LSP BUFFERS):
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <leader>vca     │ Show available [C]ode [A]ctions (e.g., "fix this")       │
│ <leader>rn      │ [R]e[n]ame symbol under cursor (smart rename)            │
│ <leader>d       │ Show [D]iagnostic details in a floating window           │
│ K               │ (Shift+K) Show [K]documentation (hover)                  │
│ <leader>rs      │ [R]e[s]tart the LSP server for this buffer               │
│ <A-h>           │ (Alt+h in Insert Mode) Show signature/parameter help     │
└─────────────────┴──────────────────────────────────────────────────────────┘

CONFIGURED LSP SERVERS:
┌───────────────────────────┬────────────────────────────────────────────────────┐
│ Server Name               │ Filetypes Handled                                  │
├───────────────────────────┼────────────────────────────────────────────────────┤
│ lua_ls                    │ lua                                                │
│ emmet_language_server     │ html, js(x), ts(x), css, svelte, etc.              │
│ emmet_ls                  │ (Redundant?) html, ts(x), js(x), css, svelte       │
│ ts_ls                     │ javascript, typescript, javascriptreact, tsreact   │
│ pyright                   │ python (auto-detects `.venv`)                      │
│ clangd                    │ c, cpp, objc, cuda (requires compile_commands.json)│
└───────────────────────────┴────────────────────────────────────────────────────┘

================================================================================
--]]
