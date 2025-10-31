# NixOS Configuration - Modular and Shareable

A modern, developer-focused NixOS configuration built around the Niri compositor with system-wide theming and instant configuration updates.

## Philosophy

This configuration embodies several key principles:

- **Wayland-first**: Built entirely around modern Wayland technologies
- **Developer productivity**: Optimized for software development workflows
- **Instant feedback**: Dotfiles symlinked for immediate changes without rebuilds
- **Consistent theming**: System-wide color coordination via Stylix
- **Minimal but functional**: Clean aesthetic without bloat
- **Reproducible**: Everything declaratively configured in Nix

## Key Components

### Window Management
- **[Niri](https://github.com/YaLTeR/niri)**: Modern scrollable-tiling Wayland compositor
- **Waybar**: Status bar with custom overview integration
- **Rofi**: Application launcher with custom theming

### Input & Interaction
- **Kanata**: Advanced keyboard remapping (Caps Lock → Ctrl/Escape dual-role)
- **Mako**: Notification daemon with auto-dismiss rules
- **Swaybg**: Wallpaper management

### Development Environment
- **Kitty**: GPU-accelerated terminal emulator
- **Fish**: User-friendly shell with custom prompt
- **Neovim**: Editor with dotfile configuration
- **Git**: Version control with sensible defaults

### Theming & Aesthetics
- **Stylix**: System-wide base16 theming (currently Catppuccin Mocha)
- **GTK/Qt**: Dark theme integration
- **Consistent colors**: Automatic theming across all applications

## File Structure

```
├── flake.nix              # Flake inputs and outputs
├── configuration.nix      # System-level configuration
├── home.nix              # User-level configuration (home-manager)
├── hardware-configuration.nix # Hardware-specific settings
└── dotfiles/             # Application configurations
    ├── niri/             # Compositor configuration
    ├── waybar/           # Status bar config + Python scripts
    ├── nvim/             # Neovim configuration
    └── config.rasi       # Rofi theme
```

## Notable Features

### Instant Configuration Updates
Most configuration files are symlinked rather than copied, allowing immediate updates:
- Niri compositor settings
- Waybar configuration and scripts
- Neovim configuration
- Rofi theming

### Smart Keyboard Remapping
- Caps Lock acts as Ctrl when held, Escape when tapped
- Alt key remapped to Super (for better window management)
- Instant activation with proper tap-hold timing

### Automatic Directory Creation
- Screenshots directory auto-created on boot
- Proper user permissions and ownership

### Notification Management
- Claude Code notifications auto-dismiss after 2 seconds
- All other notifications persist until manually dismissed
- Clean, themed notification appearance

## Installation

1. Clone this repository:
   ```bash
   git clone <repository-url> ~/code/nixos-config
   cd ~/code/nixos-config
   ```

2. Update the username variable in `configuration.nix`:
   ```nix
   let
     username = "your-username";  # Change this
   ```

3. Generate your hardware configuration:
   ```bash
   sudo nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix ./
   ```

4. Build and switch:
   ```bash
   sudo nixos-rebuild switch --flake .
   ```

## Customization

### Changing Themes
Edit the Stylix theme in `configuration.nix`:
```nix
stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/THEME-NAME.yaml";
```

Popular options:
- `catppuccin-mocha.yaml` (current)
- `tokyo-night-dark.yaml`
- `dracula.yaml`
- `rose-pine.yaml`

### Adding Applications
Add packages to the `home.packages` list in `home.nix` or system packages in `configuration.nix`.

### Modifying Keybindings
Edit the binds section in `dotfiles/niri/config.kdl` for window management, or the kanata configuration in `configuration.nix` for keyboard remapping.

## Dependencies

- NixOS 25.05+
- Home Manager
- Stylix (automatically included)
- Wayland-compatible hardware

## Credits

Built with modern Nix flakes and inspired by the broader NixOS community's approach to declarative system configuration.