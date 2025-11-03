{ config, lib, pkgs, username, chosenTheme, ... }:

let
  cfg = config.myConfig.desktop;
in
{
  options.myConfig.desktop = {
    enable = lib.mkEnableOption "desktop environment configuration";
  };

  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============

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

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = { config, ... }: {
      # Niri configuration file
      xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/modules/desktop/dotfiles/config.kdl";

      # Desktop services
      systemd.user.services = {
        # swaybg wallpaper service
        swaybg = {
          Unit = {
            Description = "Wayland wallpaper tool";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
            Requisite = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.swaybg}/bin/swaybg -i $(${pkgs.fd}/bin/fd -t f . $HOME/.config/themes/${chosenTheme}/wallpapers/ | ${pkgs.coreutils}/bin/shuf -n 1) --mode fill'";
            Restart = "on-failure";
          };
          Install = {
            WantedBy = [ "niri.service" ];
          };
        };

        # swayidle idle management service
        swayidle = {
          Unit = {
            Description = "Idle manager for Wayland";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
            Requisite = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 601 'niri msg action power-off-monitors' timeout 600 'swaylock -f' before-sleep 'swaylock -f'";
            Restart = "on-failure";
          };
          Install = {
            WantedBy = [ "niri.service" ];
          };
        };
      };
    };
  };
}
