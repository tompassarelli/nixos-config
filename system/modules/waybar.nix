{ config, lib, pkgs, ... }:

{
  # Waybar status bar for Wayland
  environment.systemPackages = with pkgs; [
    waybar               # status bar
  ];
}