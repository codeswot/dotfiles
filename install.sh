#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Deploying {C}odeswot dotfiles..."

# 1. Ensure target directories exist
mkdir -p "$HOME/.config" "$HOME/.local/bin"

# 2. Deploy user configs
echo "==> Copying configurations to ~/.config..."
cp -r "$DOTFILES_DIR/.config/"* "$HOME/.config/"

# 3. Deploy local binaries
echo "==> Installing custom scripts to ~/.local/bin..."
cp -r "$DOTFILES_DIR/.local/bin/"* "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/"*

# 4. Set theme
echo "==> Applying Codeswot theme..."
if command -v omarchy &>/dev/null; then
  omarchy theme set codeswot || true
  omarchy-shell shell rescanPlugins || true
  omarchy restart shell || true
fi

if command -v hyprctl &>/dev/null; then
  hyprctl reload || true
fi

echo ""
echo "==> User configurations applied successfully!"
echo "Optional system-level boot styling (requires sudo):"
echo "  sudo omarchy plymouth set '#111c18' '#509475' \"$HOME/.config/omarchy/branding/logo.png\""
