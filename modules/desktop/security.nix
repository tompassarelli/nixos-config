{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.myConfig.desktop.security.enable {
    # Security and authentication
    security.polkit.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;

    # Keyring services
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
  };
}
