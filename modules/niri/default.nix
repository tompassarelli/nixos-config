{ lib, ... }:
{
  options.myConfig.niri = {
    enable = lib.mkEnableOption "Enable niri compositor configuration";
  };

  imports = [
    ./niri.nix
    ./xwayland-satellite.nix
    ./swaybg.nix
    ./swayidle.nix
  ];
}
