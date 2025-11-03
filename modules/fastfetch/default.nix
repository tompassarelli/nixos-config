{ config, lib, pkgs, ... }:
{
  options.myConfig.fastfetch = {
    enable = lib.mkEnableOption "Enable fastfetch system info display";
  };

  config = lib.mkIf config.myConfig.fastfetch.enable {
    environment.systemPackages = with pkgs; [ fastfetch ];
  };
}
