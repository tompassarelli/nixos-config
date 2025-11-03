{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.mako;
in
{
  options.myConfig.mako = {
    enable = lib.mkEnableOption "Mako notification daemon";
  };

  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
      settings = {
        default-timeout = 0; # Don't auto-dismiss notifications
        icons = 0; # Hide app icons

        # Claude Code notifications auto-dismiss after 2 seconds
        "app-name=kitty" = {
          default-timeout = 2000;
        };
      };
    };
  };
}
