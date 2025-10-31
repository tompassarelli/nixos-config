{ config, lib, pkgs, ... }:

{
  # On-demand Bluetooth configuration
  # Import this file to enable, comment import to disable
  
  # Hardware Bluetooth support (off at boot)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  
  # Blueman GUI tools
  services.blueman.enable = true;
  environment.systemPackages = with pkgs; [
    blueman
  ];
}