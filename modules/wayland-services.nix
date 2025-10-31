{ config, lib, pkgs, ... }:

{
  # Wayland desktop services
  # All the systemd user services for the Wayland desktop environment
  
  # swaybg wallpaper service
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland wallpaper tool";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i %h/code/nixos-config/wallpaper.jpg";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  # waybar status bar service
  systemd.user.services.waybar = {
    Unit = {
      Description = "Highly customizable Wayland bar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  # waybar overview script service
  systemd.user.services.waybar-overview = {
    Unit = {
      Description = "Waybar overview listener script";
      PartOf = [ "graphical-session.target" ];
      After = [ "waybar.service" ];
      Requires = [ "waybar.service" ];
    };
    Service = {
      ExecStart = "%h/.config/waybar/overview-waybar.py";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  # swayidle idle management service
  systemd.user.services.swayidle = {
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

  # walker service (runs in background for fast launch)
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
      BusName = "me.halfmexican.walker";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  # notifications
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 0; # Don't auto-dismiss notifications
      icons = 0; # Hide app icons
      
      # Claude Code notifications auto-dismiss after 3 seconds
      "app-name=kitty" = {
        default-timeout = 3000;
      };
    };
  };
}
