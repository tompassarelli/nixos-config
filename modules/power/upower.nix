{ config, lib, ... }:
{
  config = lib.mkIf config.myConfig.power.enable {
    # Power monitoring
    services.upower.enable = true;
  };
}
