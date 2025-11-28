{ lib, ... }:
{
  options.myConfig.shell = {
    enable = lib.mkEnableOption "Shell environment configuration";
  };

  imports = [
    ./fish.nix
  ];
}
