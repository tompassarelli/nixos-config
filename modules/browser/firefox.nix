{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.browser;
in
{
  config = lib.mkIf (cfg.enable && cfg.firefox.enable) {
    programs.firefox.enable = true;

    # Set as default browser if specified
    xdg.mime.defaultApplications = lib.mkIf (cfg.default == "firefox") {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
