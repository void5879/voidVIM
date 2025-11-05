----------------------------------------------------------------------------------------
<div style="text-align: center;">
<pre>
 ▄█    █▄   ▄██████▄   ▄█  ████████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   
███    ███ ███    ███ ███  ███   ▀███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ 
███    ███ ███    ███ ███▌ ███    ███ ███    ███ ███▌ ███   ███   ███ 
███    ███ ███    ███ ███▌ ███    ███ ███    ███ ███▌ ███   ███   ███ 
███    ███ ███    ███ ███▌ ███    ███ ███    ███ ███▌ ███   ███   ███ 
███    ███ ███    ███ ███  ███    ███ ███    ███ ███  ███   ███   ███ 
███    ███ ███    ███ ███  ███   ▄███ ███    ███ ███  ███   ███   ███ 
 ▀██████▀   ▀██████▀  █▀   ████████▀   ▀██████▀  █▀    ▀█   ███   █▀  
                                                                      
</pre>
</div>

---

My digital cockpit. Built for flow, speed, and zero friction.

## ∴ G A L L E R Y ∴

---

![screenshot-1](assets/voidvim.png)
![screenshot-2](assets/completion.png)
![screenshot-3](assets/mini.png)

---

## ⏚ B O O T S T R A P ⏚
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone
git clone https://github.com/void5879/voidVIM.git ~/.config/nvim
cd ~/.config/nvim
rm -rf assets/

# Launch
nvim
```

**Prerequisites:** `nvim 0.11+`, Nerd Font, `git`, `ripgrep`, `fzf`

---

## 🐧 NixOS Users

**This config is designed for NixOS/Home Manager!** Instead of using Mason to install LSP servers and tools, add them to your `home.nix`:
```nix
home.packages = with pkgs; [
  # Dev Tools
  neovim
  git
  ripgrep
  fzf
  
  # LSP Servers
  lua-language-server              # lua_ls
  clang-tools                      # clangd + clang-format
  typescript-language-server       # ts_ls
  pyright                          # pyright
  rust-analyzer                    # rust_analyzer
  vscode-langservers-extracted     # html, css, json, eslint
  emmet-ls                         # emmet_ls
  emmet-language-server            # emmet_language_server
  tailwindcss-language-server      # tailwindcss
  jdt-language-server              # java (jdtls)
  marksman                         # markdown
  nil                              # nix
  
  # Formatters
  google-java-format               # java
  stylua                           # lua
  nixpkgs-fmt                      # nix
  black                            # python
  isort                            # python imports
  nodePackages.prettier            # js/ts/html/css
  biome                            # fast js/ts/json (prettier alternative)
  # rustfmt comes with rustc
  # clang-format comes with clang-tools
  
  # Linters
  luajitPackages.luacheck          # lua
  pylint                           # python
  cpplint                          # c++
];
```

Then run:
```bash
home-manager switch
```

**Remove Mason's directory** (optional but recommended):
```bash
rm -rf ~/.local/share/nvim/mason
```

Mason plugins can stay in the config for the UI, but set `ensure_installed = {}` to prevent auto-installation.

---

## ⚠️ MANUAL SETUP REQUIRED

### For Non-NixOS Users:

**1. Install LSP Servers via Mason**  
On first launch, run `:Mason` and install the language servers you need, or let Mason auto-install them.

**2. Change Java (JDTLS) Paths**  
If you're using Java, edit `lua/plugins/jdtls.lua` and update the hardcoded paths in the `cmd = { ... }` table to match your system.

### For NixOS Users:

**1. JDTLS Configuration**  
The `jdtls` Nix package provides a wrapper that handles paths automatically. Your config should use:
```lua
cmd = { 'jdtls', '-data', workspace_dir }
```
No hardcoded paths needed!

### For Everyone:

**2. Change Colorscheme**  
The active theme is set in `lua/plugins/colorscheme.lua`. By default, `github_dark_high_contrast` is enabled. Edit the file to switch themes.

---

## 🏗️ Built With

Built around `snacks.nvim` and `mini.nvim` for a cohesive, lightweight experience.

---

## 📦 Core Plugins

- **snacks.nvim** - Swiss army knife plugin suite
- **mini.nvim** - Collection of minimal, independent plugins
- **lazy.nvim** - Modern plugin manager
- **telescope.nvim** - Fuzzy finder
- **nvim-lspconfig** - LSP configurations
- **nvim-cmp** - Autocompletion
- **conform.nvim** - Formatting
- **nvim-lint** - Linting

---

**Philosophy:** Declarative, reproducible, and distraction-free.
