{ config, lib, pkgs, chosenTheme, ... }:

let
  cfg = config.myConfig.styling;
in
{
  options.myConfig.styling = {
    enable = lib.mkEnableOption "system-wide theming and styling";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${chosenTheme}.yaml";
    };
  };
}