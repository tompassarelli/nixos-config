{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.steam;
in
{
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
}
