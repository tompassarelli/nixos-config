{ lib, ... }:
{
  options.myConfig.security = {
    enable = lib.mkEnableOption "Enable security configuration";
  };

  imports = [
    ./polkit.nix
  ];
}
