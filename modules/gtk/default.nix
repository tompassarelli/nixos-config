{ config, lib, pkgs, username, ... }:

let
  cfg = config.myConfig.gtk;
in
{
  options.myConfig.gtk = {
    enable = lib.mkEnableOption "GTK theming configuration";
  };

  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============
    # (None needed - gtk is configured via home-manager)

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = {
      gtk = {
        enable = true;
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };
    };
  };
}
