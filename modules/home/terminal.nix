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

  #window_padding_width = 0;
  #window_margin_width = 0;
  #window_border_width = 0;
  #single_window_margin_width = 0;
}
