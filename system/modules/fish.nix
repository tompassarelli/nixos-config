{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.fish;
in
{
  options.myConfig.fish = {
    enable = lib.mkEnableOption "Fish shell";
  };

  config = lib.mkIf cfg.enable {
    programs.fish.enable = true;
  };
}