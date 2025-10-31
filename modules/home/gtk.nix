{ config, pkgs, ... }:

{
  # GTK theming configuration
  # Requires home-manager for gtk settings
  
  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}