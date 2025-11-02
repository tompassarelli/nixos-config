{ config, lib, pkgs, ... }:

{
  # Network configuration
  networking.networkmanager.enable = true;
  
  # Network utilities
  environment.systemPackages = with pkgs; [
    networkmanagerapplet # frontend for networkmanager
  ];
}