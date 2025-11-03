{ config, lib, pkgs, ... }:
{
  options.myConfig.btop = {
    enable = lib.mkEnableOption "Enable btop system monitor";
  };

  config = lib.mkIf config.myConfig.btop.enable {
    environment.systemPackages = with pkgs; [ btop ];
  };
}
