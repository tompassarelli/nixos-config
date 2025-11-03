{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.timezone;
in
{
  options.myConfig.timezone = {
    enable = lib.mkEnableOption "timezone configuration";
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = "America/New_York";
  };
}