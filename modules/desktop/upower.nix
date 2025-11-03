{ config, lib, ... }:
{
  config = lib.mkIf config.myConfig.desktop.upower.enable {
    # Power monitoring
    services.upower.enable = true;
  };
}
