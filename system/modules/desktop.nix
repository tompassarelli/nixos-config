{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.desktop;
in
{
  options.myConfig.desktop = {
    enable = lib.mkEnableOption "desktop environment configuration";
  };

  config = lib.mkIf cfg.enable {
    # Desktop Portal for app integration
    xdg.portal.enable = true;
  xdg.portal.extraPortals = [ 
    pkgs.xdg-desktop-portal-gtk  # for GTK apps, Electron apps (Discord, Obsidian, etc.)
    pkgs.xdg-desktop-portal-wlr  # for screen sharing on wlroots compositors
    pkgs.kdePackages.xdg-desktop-portal-kde  # for Qt apps (KDE apps, VLC, Qt Creator, etc.)
  ];
  xdg.portal.config.common.default = [ "wlr" "gtk" ];

  # Font configuration
  fonts.fontconfig.enable = true;

  # Audio with PipeWire
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    # alsa.enable = true; # can be useful if encountering issues with older apps/games
  };

  # Touchpad support
  services.libinput.enable = true;

  # Power monitoring
  services.upower.enable = true;

  # Security and authentication
  security.polkit.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Keyring services
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

    # Enable niri compositor
    programs.niri.enable = true;
  };
}
