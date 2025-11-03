{ lib, ... }:
{
  options.myConfig.web-browser = {
    enable = lib.mkEnableOption "Enable browser configuration";

    firefox.enable = lib.mkEnableOption "Enable Firefox browser";
    chromium.enable = lib.mkEnableOption "Enable Ungoogled Chromium browser";

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
