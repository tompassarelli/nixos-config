{ config, lib, pkgs, username, ... }:

let
  cfg = config.myConfig.wl-gammarelay;
in
{
  options.myConfig.wl-gammarelay = {
    enable = lib.mkEnableOption "wl-gammarelay gamma control for Wayland";
  };

  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============

    environment.systemPackages = with pkgs; [
      wl-gammarelay-rs  # live gamma control for wayland
    ];

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = { config, ... }: {
      # Temperature control script
      xdg.configFile."wl-gammarelay/temperature-control".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/dotfiles/wl-gammarelay/temperature-control";

      # wl-gammarelay systemd service
      systemd.user.services.wl-gammarelay = {
        Unit = {
          Description = "Gamma control for Wayland";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
          Requisite = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.wl-gammarelay-rs}/bin/wl-gammarelay-rs";
          Restart = "on-failure";
          Type = "dbus";
          BusName = "rs.wl-gammarelay";
        };
        Install = {
          WantedBy = [ "niri.service" ];
        };
      };
    };
  };
}
