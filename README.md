# Tom's NixOS Configuration

## Overview

This is a Level 4 NixOS configuration featuring:
- **Flakes** for reproducible builds
- **Multi-host** management (whiterabbit + thinkpad-x1e)
- **Custom module system** with `myConfig.*` namespace
- **Out-of-store symlinks** for live config editing
- **home-manager** integration

## Active Development

See [todo.org](todo.org) for current tasks and planned improvements.

## Quick Start

### Rebuild System
```bash
rebuild              # Auto-detects hostname
rebuild whiterabbit  # Explicit host
```

### Update Dependencies
```bash
nix flake update     # Update flake.lock
rebuild              # Apply updates
```

### Add a New Module
1. Create `modules/my-app/default.nix`
2. Add option in `default.nix`
3. Implement in `my-app.nix`
4. Enable in `hosts/whiterabbit/configuration.nix`

## Project Structure

```
.
├── flake.nix                    # Flake inputs, outputs, mkSystem builder
├── hosts/                       # Per-host configurations
│   ├── whiterabbit/             # Framework 13 laptop
│   └── thinkpad-x1e/            # Old laptop
├── modules/                     # Feature modules (myConfig.*)
│   ├── niri/                    # Window manager
│   ├── shell/                   # Fish shell
│   ├── neovim/                  # Editor
│   └── ...                      # 40+ modules
├── dotfiles/                    # Out-of-store configs (live editing)
│   ├── niri/config.kdl
│   ├── doom/
│   └── ...
└── manual/                      # Deep-dive documentation
    ├── nix-basics.org           # /nix/store, levels, git+generations
    ├── module-system.org        # Fixpoint eval, types, options
    └── applications.org         # App-specific tips (niri, walker)
```

## Documentation

### For Understanding NixOS
→ [manual/nix-basics.org](manual/nix-basics.org)
- How /nix/store works
- Why you can't edit /etc
- mkOutOfStoreSymlink explained
- Configuration complexity levels (0-5)
- Where you are vs where you started

### For Understanding the Module System
→ [manual/module-system.org](manual/module-system.org)
- Fixpoint evaluation
- Type system and merge semantics
- specialArgs vs module options
- Why module options are superior

### For Application-Specific Notes
→ [manual/applications.org](manual/applications.org)
- Niri (window manager tips, Minecraft compatibility)
- Walker (activation mode, why walker over anyrun)

### For Architecture Details

#### Module Patterns
**Simple modules** (e.g., `git/`, `btop/`): Single `default.nix` with one feature

**Complex modules** (e.g., `web-browser/`):
- `default.nix`: Declares options, imports sub-modules
- `firefox.nix`, `fennec.nix`, `chrome.nix`: Implement variants
- Allows multiple related features in one namespace

#### Configuration Flow
1. Host config sets enable flags (`myConfig.*.enable = true`)
2. Modules activate via `lib.mkIf cfg.enable`
3. Generated configs → `/nix/store` (immutable)
4. Hand-written configs → `dotfiles/` (live via mkOutOfStoreSymlink)

#### Package Sources
- **Stable** (`pkgs.*`): nixpkgs 25.05
- **Unstable** (`pkgs.unstable.*`): nixpkgs-unstable overlay
- **Flake inputs**: walker, elephant (not in nixpkgs)
- **NUR**: Firefox addons, community packages

Update: `nix flake update`

## Common Tasks

### Enable a new feature
```nix
# hosts/whiterabbit/configuration.nix
{
  myConfig.steam.enable = true;  # Add this line
}
```

```bash
rebuild
```

### Edit live configs (no rebuild needed)
```bash
vim ~/code/nixos-config/dotfiles/niri/config.kdl
# Changes take effect immediately (out-of-store symlink)
```

### Rollback
```bash
# Boot menu: select old generation
# OR
sudo nixos-rebuild switch --rollback
```

## Git + NixOS Workflow

### Best Practice
1. Make changes to config
2. `rebuild` (test it works)
3. If successful: `gita && gitc && gitp` (commit and push)
4. Never commit broken configs

### Why This Matters
- Git = your config source (recipes)
- NixOS generations = built systems (frozen meals)
- Booting old generation ≠ old git state
- Always commit after successful rebuild to keep them in sync

See [manual/nix-basics.org](manual/nix-basics.org#git--nixos-workflow) for full explanation of git, generations, and btrfs.

## Inspirations

This config draws inspiration from:
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)
- [redyf/nixdots](https://github.com/redyf/nixdots)
- [eduardofuncao/nixferatu](https://github.com/eduardofuncao/nixferatu)

## License

MIT
