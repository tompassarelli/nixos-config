{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.yazi;
in
{
  options.myConfig.yazi = {
    enable = lib.mkEnableOption "Yazi file manager";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      settings = {
        opener = {
          edit = [
            { run = "nvim \"$@\""; block = true; for = "unix"; }
          ];
        };
      };
    };
  };
}