{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.walker;
in
{
  options.myConfig.walker = {
    enable = lib.mkEnableOption "Walker modern wayland app launcher";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      walker               # modern wayland app launcher
    ];
  };
}