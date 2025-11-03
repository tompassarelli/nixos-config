{ config, lib, pkgs, username, chosenTheme, ... }:
{
  config = lib.mkIf config.myConfig.desktop.niri.enable {
    # Enable niri compositor at system level
    programs.niri.enable = true;

    home-manager.users.${username} = { config, ... }: {
      # Niri configuration file
      xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/dotfiles/niri/config.kdl";

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
