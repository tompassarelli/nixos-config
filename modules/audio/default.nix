{ lib, ... }:
{
  options.myConfig.audio = {
    enable = lib.mkEnableOption "Enable audio configuration";
  };

  imports = [
    ./pipewire.nix
  ];
}
