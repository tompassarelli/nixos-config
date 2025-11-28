# Host Configurations

This directory contains host-specific configurations for each machine in your NixOS fleet.

## Structure

```
hosts/
├── whiterabbit/          # Framework laptop
│   └── configuration.nix
├── thinkpad-x1e/         # old thinkpad
│   └── configuration.nix
└── README.md
```

## How It Works

### 1. Your Module System (Flat Hierarchy)

You use a **flat namespace** for modules:

```nix
# Each module is top-level
myConfig.niri.enable = true;
myConfig.git.enable = true;
myConfig.boot.enable = true;
```

### 2. Nixdots Module System (Nested Hierarchy)

They use **grouped namespaces**:

```nix
# Modules are grouped by category
myConfig.desktop.niri.enable = true;       # desktop category
myConfig.system.boot.enable = true;        # system category
myConfig.development.rust.enable = true;   # development category
```

**How they achieve nesting:**
- In `modules/desktop/default.nix`, they define nested options:
  ```nix
  options.myConfig.desktop = {
    niri.enable = lib.mkEnableOption "Enable niri";
    hyprland.enable = lib.mkEnableOption "Enable hyprland";
  };
  ```
- This creates `myConfig.desktop.niri` instead of `myConfig.niri`

**Your approach vs theirs:**
- **Yours**: Simpler, fewer layers, easier to understand
- **Theirs**: Better for large configs with many related modules

## Building a Specific Host

```bash
# Build whiterabbit (Framework laptop)
sudo nixos-rebuild switch --flake .#whiterabbit

# Build thinkpad-x1e (Thinkpad laptop)
sudo nixos-rebuild switch --flake .#thinkpad-x1e
```

## Adding a New Host

1. Create directory: `mkdir -p hosts/new-hostname`
2. Create config: `hosts/new-hostname/configuration.nix`
3. Add to `flake.nix`:
   ```nix
   nixosConfigurations = {
     # ... existing hosts ...

     new-hostname = self.lib.mkSystem {
       hostname = "new-hostname";
       username = "tom";
       hostConfig = ./hosts/new-hostname/configuration.nix;
       chosenTheme = "tokyo-night-dark";
     };
   };
   ```

## Host-Specific Examples

### Framework Laptop (whiterabbit)
- Framework-specific hardware support
- Auto-upgrade enabled (for travel)
- No gaming packages
- Power management optimized

### Desktop Workstation (tom-desktop)
- Custom keyboard (VIA enabled)
- Steam and game development tools
- Manual updates (no auto-upgrade)
- Bevy game engine libraries

## Module Enable/Disable Philosophy

Each host configuration is a **declarative list of enabled features**:

```nix
# Example: Minimal server config
myConfig = {
  # Core system only
  boot.enable = true;
  users.enable = true;
  networking.enable = true;
  ssh.enable = true;

  # No desktop environment
  niri.enable = false;
  waybar.enable = false;

  # No development tools
  rust.enable = false;
  claude.enable = false;
};
```

This makes it easy to see at a glance what each machine does.
