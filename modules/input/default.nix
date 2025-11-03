{ lib, ... }:
{
  options.myConfig.input = {
    enable = lib.mkEnableOption "Enable input device configuration";
  };

  imports = [
    ./libinput.nix
    ./wl-clipboard.nix
    ./brightnessctl.nix
    ./wl-gammarelay.nix
  ];
}
