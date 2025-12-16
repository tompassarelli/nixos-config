{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.networking;
  username = config.myConfig.users.username;
in
{
  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    # Enable WireGuard
    networking.firewall.checkReversePath = "loose"; # Required for WireGuard
    services.resolved.enable = true; # Required for wg-quick DNS
    # Config files go in /etc/wireguard/ - use: sudo wg-quick up wg0

    # Network utilities
    environment.systemPackages = with pkgs; [
      networkmanagerapplet # frontend for networkmanager
      remmina              # remote desktop client (RDP, VNC, SSH)
      protonvpn-gui        # Proton VPN GUI client
      protonvpn-cli        # Proton VPN CLI client
      wireguard-tools      # WireGuard CLI tools (wg, wg-quick)
    ];

    # HOME-MANAGER: Disable Remmina autostart by managing a hidden desktop file
    home-manager.users.${username} = {
      xdg.configFile."autostart/remmina-applet.desktop".text = ''
        [Desktop Entry]
        Hidden=true
      '';
    };
  };
}
