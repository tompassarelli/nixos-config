{ config, lib, ... }:
{
  config = lib.mkIf config.myConfig.desktop.libinput.enable {
    # Touchpad support
    services.libinput.enable = true;
  };
}
