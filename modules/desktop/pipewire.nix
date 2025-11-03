{ config, lib, ... }:
{
  config = lib.mkIf config.myConfig.desktop.pipewire.enable {
    # Audio with PipeWire
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      # alsa.enable = true; # can be useful if encountering issues with older apps/games
    };
  };
}
