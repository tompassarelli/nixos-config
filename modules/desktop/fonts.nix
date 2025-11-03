{ config, lib, ... }:
{
  config = lib.mkIf config.myConfig.desktop.fonts.enable {
    # Font configuration
    fonts.fontconfig.enable = true;
  };
}
