{ config, lib, pkgs, username, ... }:
{
  config = lib.mkIf config.myConfig.niri.enable {
    environment.systemPackages = with pkgs; [
      xwayland-satellite  # required for some apps like 2025 bitwarden
    ];

    # Run xwayland-satellite as a systemd user service
    home-manager.users.${username} = {
      systemd.user.services.xwayland-satellite = {
        Unit = {
          Description = "XWayland Satellite for Niri";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
