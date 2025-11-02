{ config, lib, pkgs, chosenTheme, ... }:

{
  # System-wide theming and styling
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${chosenTheme}.yaml";
  };
}