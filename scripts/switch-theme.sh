#!/usr/bin/env bash

# Theme switcher script for NixOS using walker dmenu
set -e

FLAKE_DIR="$HOME/code/nixos-config"
FLAKE_FILE="$FLAKE_DIR/flake.nix"

# List of common base16 themes
# You can expand this list or dynamically generate it
THEMES=(
    "tokyo-night-dark"
    "tokyo-night-light"
    "catppuccin-mocha"
    "catppuccin-latte"
    "dracula"
    "gruvbox-dark-hard"
    "gruvbox-light-hard"
    "nord"
    "solarized-dark"
    "solarized-light"
    "onedark"
    "everforest"
    "rose-pine"
    "rose-pine-dawn"
)

# Get current theme
CURRENT_THEME=$(grep -Po '(?<=chosenTheme = ")[^"]+' "$FLAKE_FILE" | grep -v '^#')

# Show themes in walker dmenu
SELECTED=$(printf '%s\n' "${THEMES[@]}" | walker --dmenu --prompt "Select theme:")

# Exit if no selection
if [ -z "$SELECTED" ]; then
    echo "No theme selected"
    exit 0
fi

# Exit if same theme
if [ "$SELECTED" = "$CURRENT_THEME" ]; then
    echo "Theme '$SELECTED' is already active"
    exit 0
fi

echo "Switching theme from '$CURRENT_THEME' to '$SELECTED'..."

# Backup flake.nix
cp "$FLAKE_FILE" "$FLAKE_FILE.bak"

# Update the chosenTheme line in flake.nix
sed -i "s/chosenTheme = \"$CURRENT_THEME\"/chosenTheme = \"$SELECTED\"/" "$FLAKE_FILE"

# Verify the change
if ! grep -q "chosenTheme = \"$SELECTED\"" "$FLAKE_FILE"; then
    echo "Error: Failed to update theme in flake.nix"
    mv "$FLAKE_FILE.bak" "$FLAKE_FILE"
    exit 1
fi

echo "Updated flake.nix with theme '$SELECTED'"

# Rebuild NixOS configuration
echo "Rebuilding NixOS configuration..."
if sudo nixos-rebuild switch --flake "$FLAKE_DIR#whiterabbit"; then
    echo "System rebuilt successfully!"

    # Restart services that need the new theme
    echo "Restarting services..."
    systemctl --user restart swaybg.service 2>/dev/null || true

    # You may need to restart other services here
    # systemctl --user restart waybar.service 2>/dev/null || true

    echo "Theme switched to '$SELECTED' successfully!"
    rm "$FLAKE_FILE.bak"
else
    echo "Error: nixos-rebuild failed, restoring backup"
    mv "$FLAKE_FILE.bak" "$FLAKE_FILE"
    exit 1
fi
