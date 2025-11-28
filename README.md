# Firn

A modular, shareable NixOS configuration framework.

## What is Firn?

Firn is a NixOS configuration that you can use as a foundation for your own system. Instead of forking and dealing with merge conflicts, you import Firn as a flake input and build on top of it.

**Features:**
- 40+ modules covering desktop, development, theming, and applications
- `myConfig.*` namespace for clean, declarative configuration
- Niri window manager with Wayland support
- Stylix theming integration
- home-manager integration

## Using Firn

### Option 1: Create Your Own Config (Recommended)

Create your own repo that imports Firn:

```nix
# ~/code/my-config/flake.nix
{
  inputs.firn.url = "github:tompassarelli/firn";

  outputs = { firn, ... }: {
    nixosConfigurations.my-machine = firn.lib.mkSystem {
      hostname = "my-machine";
      hostConfig = ./hosts/my-machine/configuration.nix;
      hardwareConfig = ./hosts/my-machine/hardware-configuration.nix;
    };
  };
}
```

```nix
# ~/code/my-config/hosts/my-machine/configuration.nix
{
  myConfig.system.stateVersion = "25.05";
  myConfig.users.username = "yourname";

  myConfig.niri.enable = true;
  myConfig.terminal.enable = true;
  myConfig.shell.enable = true;
  myConfig.neovim.enable = true;
  # ... enable what you need
}
```

See [`template/`](template/) for a complete starting point.

**To update Firn:**
```bash
nix flake update firn
rebuild
```

### Option 2: Fork Directly

If you want full control, fork this repo and modify it directly. You'll manage merge conflicts yourself when pulling upstream changes.

## lib.mkSystem Options

```nix
firn.lib.mkSystem {
  hostname = "my-machine";           # Required: your hostname
  hostConfig = ./configuration.nix;  # Required: your host config
  hardwareConfig = ./hardware.nix;   # Required: hardware-configuration.nix
  system = "x86_64-linux";           # Optional: default x86_64-linux
  extraModules = [ ./my-module ];    # Optional: additional modules
  extraOverlays = [ myOverlay ];     # Optional: additional overlays
  extraSpecialArgs = { foo = 1; };   # Optional: extra args for modules
}
```

## Project Structure

```
.
├── flake.nix           # Exposes lib.mkSystem for external use
├── modules/            # All available modules (myConfig.*)
├── hosts/              # Example host configurations
├── template/           # Starting point for your own config
├── dotfiles/           # Out-of-store configs (live editing)
└── manual/             # Documentation
```

## Available Modules

Enable modules in your host config with `myConfig.<module>.enable = true`:

| Category | Modules |
|----------|---------|
| System | `boot`, `users`, `networking`, `timezone`, `ssh`, `nix-settings`, `auto-upgrade`, `system` |
| Desktop | `niri`, `waybar`, `ironbar`, `rofi`, `walker`, `mako` |
| Hardware | `audio`, `bluetooth`, `input`, `kanata`, `power`, `framework`, `via` |
| Theming | `styling`, `theming`, `gtk`, `theme-switcher` |
| Terminal | `terminal`, `shell` |
| Editors | `neovim`, `doom-emacs` |
| CLI Tools | `git`, `yazi`, `btop`, `eza`, `dust`, `tree`, `procs`, `tealdeer`, `fastfetch` |
| Development | `development`, `rust`, `claude` |
| Applications | `web-browser`, `steam`, `productivity`, `creative`, `media`, `password`, `mail` |
| Security | `security` |

## Documentation

- [manual/nix-basics.md](manual/nix-basics.md) - How NixOS works, /nix/store, symlinks
- [manual/module-system.md](manual/module-system.md) - Module system deep dive
- [manual/applications.md](manual/applications.md) - Application-specific notes

## Quick Reference

**Rebuild:**
```bash
sudo nixos-rebuild switch --flake .#hostname
```

**Update dependencies:**
```bash
nix flake update
```

**Rollback:**
```bash
sudo nixos-rebuild switch --rollback
# Or select old generation from boot menu
```

## Inspired by

- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)
- [redyf/nixdots](https://github.com/redyf/nixdots)
- [eduardofuncao/nixferatu](https://github.com/eduardofuncao/nixferatu)

## License

MIT
