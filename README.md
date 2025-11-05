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

**Prerequisites:** `nvim 0.11+`, Nerd Font, `git`, `ripgrep`, `fzf`, `fd`, `unzip`, `lazygit`, `ghostscript`, `tectonic`, `mermaid-cli`

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
  unzip
  fd
  lazygit
  ghostscript
  tectonic
  mermaid-cli
  
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
  rustfmt                          # rust formatter
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

## ⚠️ ATTENTION: MANUAL SETUP REQUIRED

After cloning, you must do the following:

**1. Change Java (JDTLS) Paths**  
The file lua/plugins/jdtls.lua contains hardcoded paths to my local Java runtime and JDTLS executables. You must edit this file and update the paths in the cmd = { ... } table to match your own system's locations.

**2. Change Colorscheme Manually**  
The active theme is set in lua/plugins/colorscheme.lua. By default, github_dark_high_contrast is enabled. To change it, you must edit that file, comment out the active vim.cmd("colorscheme ...") line, and uncomment the one you want (e.g., kanagawa).

---

## 🏗️ Built With

Built around `snacks.nvim` and `mini.nvim` for a cohesive, lightweight experience.

---

## 📦 Core Plugins

- **snacks.nvim** - Swiss army knife plugin suite
- **mini.nvim** - Collection of minimal, independent plugins
- **lazy.nvim** - Modern plugin manager
- **nvim-lspconfig** - LSP configurations
- **nvim-cmp** - Autocompletion
- **conform.nvim** - Formatting
- **nvim-lint** - Linting

---

**Philosophy:** Declarative, reproducible, and distraction-free.
