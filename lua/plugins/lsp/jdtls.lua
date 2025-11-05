--[[
================================================================================
                        JDTLS (JAVA LSP) CONFIGURATION
================================================================================

This file configures `nvim-jdtls`, the primary plugin for Java language
support in Neovim. It handles starting and attaching to the Java Language
Server.

WHAT JDTLS DOES:
- Provides rich Java language features: completion, diagnostics,
  go-to-definition, refactoring, debugging, etc.
- Requires a running Java Language Server (JDTLS) instance.

KEY FEATURES OF THIS CONFIG:
- Autostart: Uses a Neovim autocommand to start JDTLS *only* when a
  .java file is opened, saving resources.
- Dynamic Workspaces: Automatically creates a separate JDTLS data
  directory for each project based on its folder name.
- Hardcoded Paths: This configuration uses specific, hardcoded paths
  to your Java runtime and JDTLS JAR files.

WARNING:
This configuration is highly specific to your local machine setup.
The paths for `java` and the JDTLS launcher JAR file will break if
your Java version changes or if Mason updates the `jdtls` package.
================================================================================
--]]

return {
	"mfussenegger/nvim-jdtls",

	-- ═══════════════════════════════════════════════════════════════════════
	--                              LOADING STRATEGY
	-- ═══════════════════════════════════════════════════════════════════════

	-- This plugin is configured to load via a manual autocommand below
	-- instead of lazy.nvim's `ft` key. This allows for more complex
	-- setup logic *before* the server starts.
	-- The `ft = "java"` key has been removed as noted.

	-- ═══════════════════════════════════════════════════════════════════════
	--                              MAIN CONFIGURATION
	-- ═══════════════════════════════════════════════════════════════════════

	config = function()
		-- Create an autocommand to configure and start JDTLS
		-- This runs *only* when a file with FileType 'java' is opened.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				local jdtls = require("jdtls")

				-- ═════════════════════════════════════════════════════════
				--                  DYNAMIC WORKSPACE SETUP
				-- ═════════════════════════════════════════════════════════

				-- Get the name of the parent directory (the project folder)
				local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
				-- Create a unique data directory for this project
				local workspace_dir = "/home/<YOURSYSTEM>/Projects/jdtls_data/" .. project_name
				-- Experimenting Stuff...
				-- local java_bin = vim.env.JAVA_HOME .. "/bin/java"
				-- local jdtls_path = vim.fn.trim(vim.fn.system("readlink -f $(which jdtls)"))
				-- local jdtls_dir = vim.fn.fnamemodify(jdtls_path, ":h:h") .. "/share/java"
				-- local launcher_jar = vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")

				-- ═════════════════════════════════════════════════════════
				--                    JDTLS SERVER CONFIG
				-- ═════════════════════════════════════════════════════════
				local config = {
					-- The command to execute to start the JDTLS server
					cmd = {
						-- 1. Java Executable Path (HARDCODED)
						-- java_bin,
						"/usr/lib/jvm/java-25-openjdk/bin/java",

						-- 2. JVM Options
						"-Declipse.application=org.eclipse.jdt.ls.core.id1",
						"-Dosgi.bundles.defaultStartLevel=4",
						"-Declipse.product=org.eclipse.jdt.ls.core.product",
						"-Dlog.protocol=true",
						"-Dlog.level=ALL",
						"-Xmx1g",
						"--add-modules=ALL-SYSTEM",
						"--add-opens",
						"java.base/java.util=ALL-UNNAMED",
						"--add-opens",
						"java.base/java.lang=ALL-UNNAMED",

						-- 3. JDTLS Launcher JAR Path (HARDCODED)
						"-jar",
						-- launcher_jar,
						"/home/<YOURSYSTEM>/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.100.v20251014-1222.jar",

						-- 4. JDTLS Configuration Path (HARDCODED)
						"-configuration",
						-- jdtls_dir .. "/config_linux",
						"/home/<YOURSYSTEM>/.local/share/nvim/mason/packages/jdtls/config_linux",

						-- 5. Workspace Data Path (Dynamic)
						"-data",
						workspace_dir,
					},

					-- ═════════════════════════════════════════════════════
					--                    PROJECT CONFIG
					-- ═════════════════════════════════════════════════════

					-- How to find the root of a Java project
					root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "pom.xml", "gradlew" }),

					-- Settings for the language server
					settings = {
						java = {},
					},

					-- Bundles for extensions (e.g., Lombok, Spring Boot)
					init_options = {
						bundles = {},
					},
				}

				-- ═════════════════════════════════════════════════════════
				--                       START THE SERVER
				-- ═════════════════════════════════════════════════════════
				-- This will start a new JDTLS instance or attach
				-- to an existing one for this workspace.
				jdtls.start_or_attach(config)
			end,
		})
	end,
}

--[[
================================================================================
                              QUICK REFERENCE
================================================================================

BEHAVIOR:
- When you open a `.java` file, the `FileType` autocommand triggers.
- It calculates a project-specific workspace path in
  `/home/<YOURSYSTEM>/Projects/jdtls_data/`.
- It launches the Java Language Server using the hardcoded paths in the `cmd` table.

┌─────────────────────────────────────────────────────────────────────────────┐
│ ⚠️  WARNING: HARDCODED PATHS                                                │
├─────────────────────────────────────────────────────────────────────────────┤
│ This configuration relies on specific paths on your system:                 │
│                                                                             │
│ 1. Java Runtime:                                                            │
│    `/usr/lib/jvm/java-25-openjdk/bin/java`                                  │
│ 2. JDTLS Launcher JAR:                                                      │
│    `/home/<YOURSYSTEM>/.local/share/nvim/mason/packages/jdtls/plugins/...`  │
│ 3. JDTLS Config:                                                            │
│    `/home/<YOURSYSTEM>/.local/share/nvim/mason/packages/jdtls/config_linux` │
│                                                                             │
│ If you update Java or if `Mason` updates the `jdtls` package, these paths   │
│ will likely change and this configuration will **BREAK**.                   │
│ You will need to manually update these paths to match the new locations.    │
└─────────────────────────────────────────────────────────────────────────────┘

================================================================================
--]]
