{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.mako;
  username = config.myConfig.users.username;
in
{
  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============
    # (None needed - mako is installed via home-manager)

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = {
      services.mako = {
        enable = true;
        settings = {
          default-timeout = 0; # Don't auto-dismiss notifications
          icons = 0; # Hide app icons

          # Claude Code notifications auto-dismiss after 2 seconds
          "app-name=kitty" = {
            default-timeout = 2000;
          };

          # Suppress Spotify track change notifications
          "app-name=Spotify" = {
            invisible = 1;
          };
        };
      };
    };
  };
}
