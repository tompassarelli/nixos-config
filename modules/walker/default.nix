{ config, lib, pkgs, username, inputs, ... }:

let
  cfg = config.myConfig.walker;
in
{
  options.myConfig.walker = {
    enable = lib.mkEnableOption "Walker modern wayland app launcher";
  };

  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============

    environment.systemPackages = with pkgs; [
      # Helper script for workspace renaming with walker dmenu mode
      (pkgs.writeShellScriptBin "walker-rename-workspace" ''
        name=$(echo "" | walker --dmenu --forceprint)
        [ -n "$name" ] && niri msg action set-workspace-name "$name"
      '')
    ];

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = { config, ... }: {
      # Import walker home-manager module
      imports = [ inputs.walker.homeManagerModules.default ];

      # Enable walker and elephant with runAsService
      programs.walker = {
        enable = true;
        runAsService = true;

        # Configure dmenu for workspace renaming and applications launcher
        config = {
          providers = {
            default = ["desktopapplications" "runner" "calc" "windows"];
            empty = ["desktopapplications"];
          };

          keybinds = {
            quick_activate = ["alt a" "alt s" "alt d" "alt f" "alt j" "alt k" "alt l" "alt semicolon"];
          };

          builtins.applications = {
            actions = {
              start = {
                activation_mode = {
                  type = "key";
                  key = "Return";
                };
              };
            };
          };

          builtins.windows = {
            actions = {
              activate = {
                activation_mode = {
                  type = "key";
                  key = "Return";
                };
              };
            };
          };

          builtins.dmenu = {
            hidden = false;
            weight = 5;
            name = "dmenu";
            placeholder = "Rename Workspace";
            switcher_only = false;
            show_icon_when_single = true;
          };
        };
      };
    };
  };
}
