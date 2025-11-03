{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.mail;
in
{
  options.myConfig.mail = {
    enable = lib.mkEnableOption "email applications";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      protonmail-desktop   # encrypted mail
    ];
  };
}