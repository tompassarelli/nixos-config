{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.firefox;
in
{
  options.myConfig.firefox = {
    enable = lib.mkEnableOption "Firefox web browser";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox.enable = true;
  };
}