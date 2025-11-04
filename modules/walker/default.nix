{ config, lib, pkgs, username, ... }:

let
  cfg = config.myConfig.walker;
in
{
  options.myConfig.walker = {
    enable = lib.mkEnableOption "Walker modern wayland app launcher";
  };

  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============

    environment.systemPackages = with pkgs; [
      walker  # modern wayland app launcher

      # Helper script for workspace renaming with walker dmenu mode
      (pkgs.writeShellScriptBin "walker-rename-workspace" ''
        name=$(echo "" | walker --dmenu --forceprint)
        [ -n "$name" ] && niri msg action set-workspace-name "$name"
      '')
    ];

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = { config, ... }: {
      # Walker configuration file
      xdg.configFile."walker/config.toml".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/dotfiles/walker/config.toml";

      # Walker systemd service (runs in background for fast launch)
      systemd.user.services.walker = {
        Unit = {
          Description = "Walker application launcher service";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
          Requisite = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.walker}/bin/walker --gapplication-service";
          Restart = "on-failure";
          Type = "dbus";
          BusName = "dev.benz.walker";
        };
        Install = {
          WantedBy = [ "niri.service" ];
        };
      };
    };
  };
}
