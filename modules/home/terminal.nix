{ config, pkgs, ... }:

{
  # Terminal configuration
  # Requires home-manager for programs.kitty
  
  programs.kitty = {
    enable = true;
    settings = {
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
    };
  };
}