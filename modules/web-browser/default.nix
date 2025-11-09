{ lib, ... }:
{
  options.myConfig.web-browser = {
    enable = lib.mkEnableOption "Enable browser configuration";

    firefox.enable = lib.mkEnableOption "Enable Firefox browser (minimal/vanilla)";
    fennec.enable = lib.mkEnableOption "Enable Fennec (Firefox with custom UI styling)";
    chrome.enable = lib.mkEnableOption "Enable Google Chrome browser";

    default = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "firefox" "fennec" "chrome" ]);
      default = "fennec";
      description = "Default browser (firefox, fennec, or chrome)";
    };
  };

  imports = [
    ./firefox.nix
    ./fennec.nix
    ./chrome.nix
  ];
}
