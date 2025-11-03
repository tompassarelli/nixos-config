{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.browser;
in
{
  options.myConfig.browser = {
    enable = lib.mkEnableOption "browser configuration";

    firefox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Firefox browser";
      };
    };

    chromium = {
      enable = lib.mkEnableOption "Ungoogled Chromium browser";
    };

    default = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "firefox" "chromium" ]);
      default = "firefox";
      description = "Default browser (firefox or chromium)";
    };
  };

  imports = [
    ./firefox.nix
    ./chromium.nix
  ];
}
