{ lib, ... }:
{
  options.myConfig.terminal = {
    enable = lib.mkEnableOption "Kitty terminal configuration";
  };

  imports = [
    ./kitty.nix
  ];
}
