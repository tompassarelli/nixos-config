# niri setting if using minecraft
_JAVA_AWT_WM_NONREPARENTING=1

from: https://www.reddit.com/r/unixporn/comments/1lyni3b/niri_noctalia_quiet_by_design_nixos_quickshell/


# Walker Application Launcher

## Why Walker over Anyrun
- Actively developed (v2.9.0 Nov 2025) vs Anyrun (maintenance mode)
- More features: AI integration, clipboard history, bookmarks
- Works great on niri (most features are generic Wayland, only one optional Hyprland module)
- Already in nixpkgs
- Anyrun has flickering issue (no input debouncing, re-sorts on every keystroke)

## Activation Mode Feature
Walker's "activation_mode" allows quick item selection via modifier key + letter:
- Hold Right Alt (ralt) + press letter keys (j/k/l/;/a/s/d/f)
- Letters appear on the right side of each result
- Instantly activates the corresponding item

### Configuration
```toml
[keys]
trigger_labels = "ralt"  # Use Right Alt as trigger modifier

[activation_mode]
labels = "jkl;asdf"  # Letters used for quick selection
```

Config location: `dotfiles/walker/config.toml` (managed via mkOutOfStoreSymlink)
