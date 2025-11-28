{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.networking;
  username = config.myConfig.users.username;
in
{
  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    # Network utilities
    environment.systemPackages = with pkgs; [
      networkmanagerapplet # frontend for networkmanager
      remmina              # remote desktop client (RDP, VNC, SSH)
      protonvpn-gui        # Proton VPN GUI client
      protonvpn-cli        # Proton VPN CLI client
    ];

    # HOME-MANAGER: Remmina autostart configuration
    home-manager.users.${username} = { config, ... }: {
      # Disable Remmina autostart when not enabled
      xdg.configFile."autostart/remmina-applet.desktop" = lib.mkIf (!cfg.remmina.autostart) {
        source = config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/code/nixos-config/dotfiles/autostart/remmina-applet.desktop";
      };
    };
  };
}
