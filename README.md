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

## ⚠️ ATTENTION: MANUAL SETUP REQUIRED

After cloning, you must do the following:

**1. Change Java (JDTLS) Paths**  
The file `lua/plugins/jdtls.lua` contains hardcoded paths to my local Java runtime and JDTLS executables. You must edit this file and update the paths in the `cmd = { ... }` table to match your own system's locations.

**2. Change Colorscheme Manually**  
The active theme is set in `lua/plugins/colorscheme.lua`. By default, `github_dark_high_contrast` is enabled. To change it, you must edit that file, comment out the active `vim.cmd("colorscheme ...")` line, and uncomment the one you want (e.g., `kanagawa`).

---

Built around `snacks.nvim` and `mini.nvim` for a cohesive, lightweight experience.
