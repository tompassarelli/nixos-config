{ config, lib, inputs, pkgs, username, ... }:

let
  cfg = config.myConfig.anyrun;
in
{
  options.myConfig.anyrun = {
    enable = lib.mkEnableOption "Anyrun application launcher";
  };

  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============

    # Helper script for workspace renaming with custom anyrun plugin
    environment.systemPackages = let
      renamePlugin = inputs.anyrun-rename-workspace.packages.${pkgs.system}.default;
    in [
      (pkgs.writeShellScriptBin "anyrun-rename-workspace" ''
        name=$(echo "" | anyrun --plugins ${renamePlugin}/lib/libanyrun_rename_workspace.so)
        [ -n "$name" ] && niri msg action set-workspace-name "$name"
      '')
    ];

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.sharedModules = [{
      # Disable home-manager's built-in anyrun module to avoid conflicts
      disabledModules = [ "programs/anyrun.nix" ];
    }];

    home-manager.users.${username} = {
      # Import the anyrun flake's home-manager module
      imports = [ inputs.anyrun.homeManagerModules.default ];

      programs.anyrun = {
        enable = true;
        config = {
          x = { fraction = 0.5; };
          y = { fraction = 0.3; };
          width = { fraction = 0.3; };
          hideIcons = false;
          ignoreExclusiveZones = false;
          layer = "overlay";
          hidePluginInfo = true;
          closeOnClick = false;
          showResultsImmediately = false;
          maxEntries = null;

          plugins = [
            inputs.anyrun.packages.${pkgs.system}.niri-focus
            inputs.anyrun.packages.${pkgs.system}.applications
          ];

          keybinds = [
            # Default keybinds
            { key = "Return"; action = "select"; }
            { key = "Escape"; action = "close"; }
            { key = "Up"; action = "up"; }
            { key = "Down"; action = "down"; }
            { key = "Tab"; action = "down"; }
            { key = "ISO_Left_Tab"; action = "up"; }
            # Vim-style navigation
            { key = "j"; ctrl = true; action = "down"; }
            { key = "k"; ctrl = true; action = "up"; }
          ];
        };

        # Stdin plugin config - allow arbitrary text input for dmenu-like usage
        extraConfigFiles."stdin.ron".text = ''
          Config(
            allow_invalid: true,
            max_entries: 5,
            preserve_order: false,
          )
        '';
      };
    };
  };
}
