{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.neovim;
in
{
  options.myConfig.neovim = {
    enable = lib.mkEnableOption "Neovim text editor";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}