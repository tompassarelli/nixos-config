{ lib, ... }:
{
  options.myConfig.power = {
    enable = lib.mkEnableOption "Enable power management";
  };

  imports = [
    ./upower.nix
  ];
}
