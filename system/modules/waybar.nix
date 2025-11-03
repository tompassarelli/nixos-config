{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.waybar;
in
{
  options.myConfig.waybar = {
    enable = lib.mkEnableOption "Waybar status bar for Wayland";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      waybar               # status bar
    ];
  };
}