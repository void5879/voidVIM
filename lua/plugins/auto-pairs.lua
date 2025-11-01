--[[
================================================================================
                        NVIM-AUTOPAIRS CONFIGURATION
================================================================================

Nvim-autopairs automatically inserts closing brackets, quotes, and parentheses
when you type the opening ones. It's like having an intelligent typing assistant
that helps maintain balanced code syntax.

WHAT AUTOPAIRS DOES:
- Automatically closes brackets: ( → ()
- Automatically closes quotes: " → ""
- Smart deletion: deleting opening bracket removes closing one too
- Works with treesitter for context-aware pairing
- Integrates with completion plugins for seamless workflow

SMART FEATURES:
- Context-aware: Won't add pairs in comments or strings (when inappropriate)
- Treesitter integration: Understands code structure for better decisions
- Completion integration: Works seamlessly with nvim-cmp

PERFORMANCE:
- Loads only when entering insert mode (lazy loading)
- Lightweight and fast - no noticeable typing delay
================================================================================
--]]

return {
	-- Automatic bracket and quote pairing plugin
	"windwp/nvim-autopairs",

	-- ═══════════════════════════════════════════════════════════════════════
	--                              LOADING STRATEGY
	-- ═══════════════════════════════════════════════════════════════════════

	-- Load only when entering insert mode (lazy loading for faster startup)
	-- This means the plugin won't slow down Neovim startup time
	event = { "BufReadPost", "BufNewFile" },

	-- ═══════════════════════════════════════════════════════════════════════
	--                              DEPENDENCIES
	-- ═══════════════════════════════════════════════════════════════════════

	dependencies = {
		-- Integration with completion plugin for seamless workflow
		-- This ensures autopairs works well with auto-completion
		"hrsh7th/nvim-cmp",
	},

	-- ═══════════════════════════════════════════════════════════════════════
	--                              MAIN CONFIGURATION
	-- ═══════════════════════════════════════════════════════════════════════

	config = function()
		-- Import nvim-autopairs plugin
		local autopairs = require("nvim-autopairs")

		-- Setup autopairs with configuration
		autopairs.setup({

			-- ═════════════════════════════════════════════════════════════
			--                      TREESITTER INTEGRATION
			-- ═════════════════════════════════════════════════════════════

			-- Enable treesitter integration for context-aware pairing
			-- This makes autopairs understand code structure and context
			-- Example: Won't add quotes inside existing strings
			check_ts = true,

			-- Language-specific treesitter configuration
			-- This tells autopairs how to behave in different code contexts
			ts_config = {
				-- Lua language rules
				lua = { "string" }, -- Don't add pairs inside lua string treesitter nodes

				-- JavaScript rules (commented out in original, but here's what it would do)
				-- javascript = { "template_string" }, -- Don't add pairs in JS template strings

				-- Java rules
				java = false, -- Don't check treesitter on java (can improve performance)
			},
		})

		-- ═════════════════════════════════════════════════════════════════
		--                      COMPLETION INTEGRATION
		-- ═════════════════════════════════════════════════════════════════

		-- Import nvim-autopairs completion functionality
		-- This allows autopairs to work with the completion menu
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		-- Import nvim-cmp plugin (completions plugin)
		local cmp = require("cmp")

		-- Make autopairs and completion work together
		-- When you accept a completion item, autopairs will handle bracket insertion
		-- Example: Completing "function" and accepting it will properly handle ()
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}

--[[
================================================================================
                              AUTOPAIRS BEHAVIOR GUIDE
================================================================================

BASIC PAIRING:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ You Type        │ Result (| = cursor position)                             │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ (               │ (|)                                                      │
│ [               │ [|]                                                      │
│ {               │ {|}                                                      │
│ "               │ "|"                                                      │
│ '               │ '|'                                                      │
│ `               │ `|` (backtick for template strings)                      │
└─────────────────┴──────────────────────────────────────────────────────────┘

SMART DELETION:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Before          │ Press Backspace → After                                  │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ (|)             │ |                                                        │
│ [|]             │ |                                                        │
│ {|}             │ |                                                        │
│ "|"             │ |                                                        │
│ '|'             │ |                                                        │
└─────────────────┴──────────────────────────────────────────────────────────┘

SMART MOVEMENT:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Before          │ Press Closing Character → After                          │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ (hello|)        │ Press ) → (hello)|                                       │
│ [world|]        │ Press ] → [world]|                                       │
│ {code|}         │ Press } → {code}|                                        │
│ "text|"         │ Press " → "text"|                                        │
└─────────────────┴──────────────────────────────────────────────────────────┘

TREESITTER SMART BEHAVIOR:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Context         │ Behavior                                                 │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ Inside strings  │ Won't auto-pair quotes (prevents nested quote issues)    │
│ Lua strings     │ Special handling for Lua string literals                 │
│ Java code       │ Treesitter checking disabled (better performance)        │
│ JS templates    │ Would avoid pairing in template strings (if enabled)     │
└─────────────────┴──────────────────────────────────────────────────────────┘

================================================================================
                              COMPLETION INTEGRATION
================================================================================

HOW IT WORKS WITH NVIM-CMP:
When you use auto-completion (nvim-cmp) and select a completion item:

EXAMPLE 1 - Function Completion:
1. Type: "prin"
2. Completion shows: "print"
3. Accept completion: "print"
4. Autopairs automatically adds: "print(|)" with cursor inside

EXAMPLE 2 - Object Method Completion:
1. Type: "obj.meth"
2. Completion shows: "obj.method"
3. Accept completion: "obj.method"
4. Autopairs adds parentheses: "obj.method(|)"

EXAMPLE 3 - Variable with Brackets:
1. Type: "arr"
2. Completion shows: "array"
3. Accept completion: "array"
4. Type "[" → autopairs adds: "array[|]"

================================================================================
                              CONFIGURATION EXPLAINED
================================================================================

KEY SETTINGS:
┌─────────────────┬──────────────────────────────────────────────────────────┐
│ Setting         │ Purpose                                                  │
├─────────────────┼──────────────────────────────────────────────────────────┤
│ check_ts = true │ Enable treesitter for smart context awareness            │
│ lua = {"string"}│ Don't add pairs inside Lua string contexts               │
│ java = false    │ Disable treesitter for Java (performance)                │
│ cmp integration │ Make autopairs work with completion menu                 │
└─────────────────┴──────────────────────────────────────────────────────────┘

TREESITTER CONTEXTS:
- "string": Inside string literals like "hello" or 'world'
- "comment": Inside code comments
- "template_string": Inside JavaScript template literals (`text`)
- false: Completely disable treesitter checking for that language

PERFORMANCE NOTES:
- Java treesitter disabled: Java files can be large, so disabling improves speed
- Lazy loading: Plugin only loads when you enter insert mode
- Completion integration: Seamless workflow without performance impact

--]]
