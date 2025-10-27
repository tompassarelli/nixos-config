{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";
  
  programs.kitty = {
    enable = true;
    settings = {
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
    };
  };
}
