{ lib, ... }:
{
  options.myConfig.web-browser = {
    enable = lib.mkEnableOption "Enable browser configuration";

    firefox.enable = lib.mkEnableOption "Enable Firefox browser (minimal/vanilla)";
    fennec.enable = lib.mkEnableOption "Enable Fennec (Firefox with custom UI styling)";
    chromium.enable = lib.mkEnableOption "Enable Ungoogled Chromium browser";

    default = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "firefox" "fennec" "chromium" ]);
      default = "fennec";
      description = "Default browser (firefox, fennec, or chromium)";
    };
  };

  imports = [
    ./firefox.nix
    ./fennec.nix
    ./chromium.nix
  ];
}
