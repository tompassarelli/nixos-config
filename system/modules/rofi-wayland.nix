{ config, lib, pkgs, ... }:

{
  # Rofi application launcher for Wayland
  environment.systemPackages = with pkgs; [
    rofi-wayland         # it works, its fast
  ];
}