{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.gtk;
in
{
  options.myConfig.gtk = {
    enable = lib.mkEnableOption "GTK theming configuration";
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
