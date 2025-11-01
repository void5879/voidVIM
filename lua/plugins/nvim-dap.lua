--[[
================================================================================
                        DEBUG ADAPTER PROTOCOL (DAP) CONFIGURATION
================================================================================

This file configures `nvim-dap`, the main plugin for enabling a full debugging
experience (like VS Code's debugger) inside Neovim.

PLUGINS IN THIS FILE:
1. `nvim-dap`: The core Debug Adapter Protocol client. It handles the logic of
   communicating with debug adapters.
2. `nvim-dap-ui`: A companion plugin that provides a graphical user interface
   for `nvim-dap`, showing stacks, breakpoints, scopes, and variables.

WHAT THIS SETUP DOES:
- Provides the core logic for debugging (breakpoints, stepping, etc.).
- Adds a GUI for visualizing the debug state (stacks, variables).
- Automatically opens the DAP UI when a debug session starts.
- Automatically closes the DAP UI when a debug session ends.
- Sets up keymaps for common debugging actions.
================================================================================
--]]

return {
	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                        1. NVIM-DAP (CORE DEBUGGER)                      │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		"mfussenegger/nvim-dap",

		-- ═══════════════════════════════════════════════════════════════════
		--                              MAIN CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════

		config = function()
			-- Import the core dap and dapui modules
			local dap, dapui = require("dap"), require("dapui")

			-- ═════════════════════════════════════════════════════════════
			--                 AUTOMATIC UI MANAGEMENT
			-- ═════════════════════════════════════════════════════════════
			-- These listeners automatically open and close the DAP UI
			-- for a seamless debugging experience.

			-- Open the DAP UI automatically when a session attaches
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			-- Open the DAP UI automatically when a session launches
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			-- Close the DAP UI when the debug session is terminated
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			-- Close the DAP UI when the debug session exits
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- ═════════════════════════════════════════════════════════════
			--                            KEYMAPS
			-- ═════════════════════════════════════════════════════════════
			-- Leader key + 'd' for Debug

			-- Step Into: Go into the function call at the cursor
			vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "DAP: Step [I]nto" }) -- 'l' is next to 'j'/'k'
			-- Step Over: Execute the current line and move to the next
			vim.keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "DAP: Step Over" }) -- 'j' for next
			-- Step Out: Finish the current function and move up the stack
			vim.keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "DAP: Step Out" }) -- 'k' for previous/up
			-- Continue: Run the code until the next breakpoint
			vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "DAP: [C]ontinue" })
			-- Toggle Breakpoint: Add or remove a breakpoint on the current line
			vim.keymap.set(
				"n",
				"<leader>db",
				"<cmd>lua require'dap'.toggle_breakpoint()<CR>",
				{ desc = "DAP: Toggle [B]reakpoint" }
			)
			-- Conditional Breakpoint: Set a breakpoint that only triggers if a condition is true
			vim.keymap.set(
				"n",
				"<leader>dd",
				"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
				{ desc = "DAP: Set [C]onditional Breakpoint" } -- 'd' for con[d]itional
			)
			-- Terminate: Stop the debug session
			vim.keymap.set(
				"n",
				"<leader>de",
				"<cmd>lua require'dap'.terminate()<CR>",
				{ desc = "DAP: Terminate/[E]nd" }
			)
			-- Run Last: Relaunch the last debug session
			vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "DAP: [R]un Last" })
		end,
	},

	-- ┌─────────────────────────────────────────────────────────────────────────┐
	-- │                       2. NVIM-DAP-UI (DEBUGGER GUI)                     │
	-- └─────────────────────────────────────────────────────────────────────────┘
	{
		"rcarriga/nvim-dap-ui",
		-- ═══════════════════════════════════════════════════════════════════
		--                              DEPENDENCIES
		-- ═══════════════════════════════════════════════════════════════════
		dependencies = {
			"mfussenegger/nvim-dap", -- Requires the core DAP plugin
			"nvim-neotest/nvim-nio", -- Required for async operations
		},
		-- ═══════════════════════════════════════════════════════════════════
		--                              MAIN CONFIGURATION
		-- ═══════════════════════════════════════════════════════════════════
		config = function()
			-- Setup dapui with default settings
			-- The UI elements (scopes, breakpoints, etc.) are configured
			-- by the plugin's defaults.
			require("dapui").setup()
		end,
	},
}

--[[
================================================================================
                              KEYMAPS REFERENCE
================================================================================

┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Key Combination │ Action                                                   │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ <leader>db      │ Toggle [B]reakpoint on the current line                  │
│ <leader>dd      │ Set [C]on[d]itional Breakpoint                           │
│ <leader>dc      │ [C]ontinue execution                                     │
│ <leader>dj      │ Step Over (next line)                                    │
│ <leader>dl      │ Step [I]nto (go into function)                           │
│ <leader>dk      │ Step Out (go out of function)                            │
│ <leader>de      │ Terminate / [E]nd session                                │
│ <leader>dr      │ [R]un last debug configuration                           │
└─────────────────┴──────────────────────────────────────────────────────────┘

================================================================================
                              BEHAVIOR GUIDE
================================================================================

A TYPICAL DEBUGGING WORKFLOW:

1.  **Set Breakpoints**: Go to the lines where you want to pause execution
    and press `<leader>db`.
2.  **Launch Debugger**: Run your language-specific "launch" command.
    (e.g., for Rust, `<leader>drc` from `rustaceanvim` might be "Debug Run").
3.  **UI Opens**: The `nvim-dap-ui` windows (Scopes, Breakpoints, Stack)
    will open automatically.
4.  **Code Stops**: The code will run and stop at your first breakpoint.
5.  **Navigate**:
    * Use `<leader>dj` to execute the current line and go to the next.
    * Use `<leader>dl` to enter a function call.
    * Use `<leader>dk` to finish the current function and return.
    * Check the `dap-ui` "Scopes" window to inspect variable values.
6.  **Continue**: Press `<leader>dc` to run until the next breakpoint.
7.  **Terminate**: Press `<leader>de` to stop the session. The `dap-ui`
    windows will close automatically.

================================================================================
--]]
