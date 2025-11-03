{ lib, ... }:
{
  options.myConfig.theming = {
    enable = lib.mkEnableOption "Enable theming configuration";
  };

  imports = [
    ./fonts.nix
    ./xdg-portal.nix
    ./themes.nix
  ];
}
