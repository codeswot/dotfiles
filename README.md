# {C}odeswot Omarchy Dotfiles

Complete personal rice and configuration setup for Omarchy Linux with Hyprland.

## Highlights
- **Top Bar**: Custom `{C}` widget styled with theme accent (`#509475`), launches terminal on click.
- **Fastfetch**: Custom `{C}` ASCII art with dynamic theme coloring and `{C}odeswot` OS labeling.
- **Screensaver**: `Codeswot` block font banner with terminal effects (`ttfx`).
- **Lock Screen**: Clean `{C}odeswot` branding centered above password prompt.
- **Floating Presentation**: `omarchy-show-logo` displays `{C}odeswot` during package updates/installs.
- **Hyprland Window Aesthetics**: Subtle window background blur (`size = 5`, `passes = 2`) with `0.95` active / `0.88` inactive opacity, and clean spacing between the top bar and active windows.
- **Theme**: Complete `Codeswot` theme with matching colors, wallpapers, and templates.

## Structure
- `.config/omarchy/`: Shell layout, plugins (`codeswot.menu`, `codeswot.lock`), branding, themes, wallpapers, hooks.
- `.config/hypr/`: Hyprland configuration, appearance, gaps, blur, bindings, monitors.
- `.config/fastfetch/`: Fastfetch configuration with custom logo and color definitions.
- `.config/ghostty/`, `alacritty/`, `kitty/`: Terminal configs with blur and padding.
- `.local/bin/`: Custom scripts (`omarchy-show-logo`).
- `system/`: Reference bootloader (`limine.conf`) and OS release configs.

## Installation on New PC
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Push to Remote Git (GitHub / GitLab)
```bash
cd ~/dotfiles
git remote add origin git@github.com:<your-username>/<your-repo>.git
git branch -M main
git push -u origin main
```
