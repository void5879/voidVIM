--[[
================================================================================
                      NEOVIM AUTO COMMANDS CONFIGURATION
================================================================================

This file defines custom automatic behaviors (autocmds) that trigger on
specific events within Neovim. This helps in automating tasks and
enhancing the user interface dynamically.

ORGANIZATION:
- LSP Progress Notifier (provides visual feedback for LSP activity)

AUTOCOMMANDS EXPLAINED:
vim.api.nvim_create_augroup(name, opts)  -- Creates a container for autocmds
vim.api.nvim_create_autocmd(event, opts) -- Defines the actual event handler

This structure keeps autocmds organized, and the { clear = true } option
in augroups prevents duplicate commands from being registered when this
file is reloaded.
================================================================================
--]]

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                        LSP PROGRESS NOTIFIER                            │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ═══════════════════════════════════════════════════════════════════════════
--                         GLOBAL PROGRESS TRACKER
-- ═══════════════════════════════════════════════════════════════════════════

-- This table will store the state of ongoing LSP progress messages.
-- It is keyed by the LSP client's ID (a number).
-- Each client ID maps to a list of progress items reported by that server.
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()

-- ═══════════════════════════════════════════════════════════════════════════
--                         LSP PROGRESS AUGROUP
-- ═══════════════════════════════════════════════════════════════════════════

-- Create a dedicated augroup for our LSP progress notifications
-- { clear = true } ensures that reloading this config file clears
-- old versions of the autocmd before creating a new one.
local lsp_progress_group = vim.api.nvim_create_augroup("LspProgressNotifier", { clear = true })

-- Create the autocmd that listens for LSP progress events
-- This function will fire every time an LSP server sends a progress update
-- (e.g., "indexing", "loading", "begin", "report", "end").
vim.api.nvim_create_autocmd("LspProgress", {
	group = lsp_progress_group,
	desc = "Handle LSP progress updates and show notifications",
	-- This is the main function that handles the progress event
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		-- 1. GET CLIENT AND VALUE
		-- ────────────────────────

		-- Get the LSP client object using the ID from the event
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		-- Get the progress payload (e.g., { kind: "begin", title: "Indexing...", message: "file.lua" })
		local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]

		-- Safety check: If client doesn't exist or value is not a table, stop
		if not client or type(value) ~= "table" then
			return
		end

		-- Get the list of current progress messages for this specific client
		-- (Using vim.defaulttable() above ensures this is always a table)
		local p = progress[client.id]

		-- 2. UPDATE OR ADD PROGRESS MESSAGE
		-- ──────────────────────────────────

		-- Loop through existing messages for this client to find a match
		for i = 1, #p + 1 do
			-- If we reach the end OR find a message with the same token, update it
			if i == #p + 1 or p[i].token == ev.data.params.token then
				-- Store the updated/new progress item
				p[i] = {
					token = ev.data.params.token,
					-- Format the message string (e.g., "[ 75%] Indexing **file.lua**")
					msg = ("[%3d%%] %s%s"):format(
						value.kind == "end" and 100 or value.percentage or 100, -- Show 100% on "end"
						value.title or "",
						value.message and (" **%s**"):format(value.message) or ""
					),
					-- Mark as 'done' if the LSP server sends the "end" signal
					done = value.kind == "end",
				}
				break -- Stop looping once we've updated the message
			end
		end

		-- 3. FILTER MESSAGES AND PREPARE FOR NOTIFICATION
		-- ────────────────────────────────────────────────

		-- This table will hold the final, formatted strings to display
		local msg = {} ---@type string[]

		-- Filter the client's progress list:
		-- 1. Keep only messages that are NOT done
		-- 2. As a side effect, add all message strings (even "done" ones) to the `msg` table
		progress[client.id] = vim.tbl_filter(function(v)
			-- Add the formatted message string to our display list
			table.insert(msg, v.msg)
			-- Return 'true' (keep) if the message is NOT done
			return not v.done
		end, p)

		-- 4. DISPLAY THE NOTIFICATION
		-- ──────────────────────────

		-- Define the spinner animation characters
		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

		-- Send the notification to the UI using vim.notify
		vim.notify(
			-- Join all messages with a newline
			table.concat(msg, "\n"),
			"info", -- Notification level (e.g., info, warn, error)
			{
				id = "lsp_progress", -- A unique ID to allow this notification to be updated
				title = client.name, -- Show the LSP client's name (e.g., "lua_ls")
				-- This function runs dynamically to update the icon
				opts = function(notif)
					-- If no progress items are left, show a checkmark
					-- Otherwise, show the next character in the spinner animation
					notif.icon = #progress[client.id] == 0 and " "
						or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
				end,
			}
		)
	end,
})

--[[
================================================================================
                              QUICK REFERENCE
================================================================================

This file configures a dynamic notification system for LSP servers.

BEHAVIOR:
┌──────────────────┬──────────────────────────────────────────────────────────┐
│ Event            │ Purpose                                                  │
├──────────────────┼──────────────────────────────────────────────────────────┤
│ LspProgress      │ Triggers on any progress update from any active LSP.     │
│ `progress` table │ Stores progress messages, grouped by LSP client ID.      │
│ `vim.notify`     │ Shows a notification with a spinner (e.g., ⠋, ⠙, ⠹).     │
│ Icon Logic       │ Shows a spinner `⠏` while working, and a checkmark ``   │
│                  │ when all tasks for that client are complete.             │
│ `vim.tbl_filter` │ Used to remove "done" messages from the `progress` table │
│                  │ so they don't appear in the next update.                 │
└──────────────────┴──────────────────────────────────────────────────────────┘

--]]
