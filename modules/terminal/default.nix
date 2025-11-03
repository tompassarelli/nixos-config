{ config, lib, pkgs, username, ... }:

let
  cfg = config.myConfig.terminal;
in
{
  options.myConfig.terminal = {
    enable = lib.mkEnableOption "Kitty terminal configuration";
  };

  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============
    # (None needed - kitty is installed via home-manager)

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = {
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
    };
  };
}
