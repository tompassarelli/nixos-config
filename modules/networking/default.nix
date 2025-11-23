{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.networking;
in
{
  options.myConfig.networking = {
    enable = lib.mkEnableOption "network configuration";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    # Network utilities
    environment.systemPackages = with pkgs; [
      networkmanagerapplet # frontend for networkmanager
      remmina              # remote desktop client (RDP, VNC, SSH)
      protonvpn-gui        # Proton VPN GUI client
      protonvpn-cli        # Proton VPN CLI client
    ];
  };
}