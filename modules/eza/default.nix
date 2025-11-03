{ config, lib, pkgs, ... }:
{
  options.myConfig.eza = {
    enable = lib.mkEnableOption "Enable eza (modern ls replacement)";
  };

  config = lib.mkIf config.myConfig.eza.enable {
    environment.systemPackages = with pkgs; [ eza ];
  };
}
