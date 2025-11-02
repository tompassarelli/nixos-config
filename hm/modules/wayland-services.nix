{ config, lib, pkgs, chosenTheme, ... }:

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
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.swaybg}/bin/swaybg -i $(${pkgs.fd}/bin/fd -t f . $HOME/.config/themes/${chosenTheme}/wallpapers/ | ${pkgs.coreutils}/bin/shuf -n 1) --mode fill'";
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

  # wl-gammarelay service for temperature control
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
}
