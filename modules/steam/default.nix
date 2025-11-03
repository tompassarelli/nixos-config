{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.steam;
in
{
  options.myConfig.steam = {
    enable = lib.mkEnableOption "Steam gaming platform";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
}