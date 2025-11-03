{ config, lib, pkgs, ... }:
{
  options.myConfig.tree = {
    enable = lib.mkEnableOption "Enable tree file tree display utility";
  };

  config = lib.mkIf config.myConfig.tree.enable {
    environment.systemPackages = with pkgs; [ tree ];
  };
}
