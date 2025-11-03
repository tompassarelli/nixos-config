{ config, lib, pkgs, ... }:
{
  options.myConfig.dust = {
    enable = lib.mkEnableOption "Enable dust disk usage analyzer";
  };

  config = lib.mkIf config.myConfig.dust.enable {
    environment.systemPackages = with pkgs; [ dust ];
  };
}
