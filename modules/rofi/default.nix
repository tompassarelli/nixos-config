{ config, lib, pkgs, username, ... }:

let
  cfg = config.myConfig.rofi-wayland;
in
{
  options.myConfig.rofi-wayland = {
    enable = lib.mkEnableOption "Rofi application launcher for Wayland";
  };

  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============

    environment.systemPackages = with pkgs; [
      rofi-wayland  # it works, its fast
    ];

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = { config, ... }: {
      # Rofi configuration file
      xdg.configFile."rofi/config.rasi".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/dotfiles/rofi/config.rasi";
    };
  };
}
