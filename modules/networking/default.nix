{ lib, ... }:
{
  options.myConfig.networking = {
    enable = lib.mkEnableOption "network configuration";
    remmina.autostart = lib.mkEnableOption "Remmina applet autostart";
  };

  imports = [
    ./networking.nix
  ];
}