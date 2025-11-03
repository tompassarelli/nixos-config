{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.rofi-wayland;
in
{
  options.myConfig.rofi-wayland = {
    enable = lib.mkEnableOption "Rofi application launcher for Wayland";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rofi-wayland         # it works, its fast
    ];
  };
}