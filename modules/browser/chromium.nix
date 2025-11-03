{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.browser;
in
{
  config = lib.mkIf (cfg.enable && cfg.chromium.enable) {
    # Install ungoogled-chromium
    environment.systemPackages = with pkgs; [
      ungoogled-chromium
    ];

    # Set as default browser if specified
    xdg.mime.defaultApplications = lib.mkIf (cfg.default == "chromium") {
      "text/html" = "chromium-browser.desktop";
      "x-scheme-handler/http" = "chromium-browser.desktop";
      "x-scheme-handler/https" = "chromium-browser.desktop";
      "x-scheme-handler/about" = "chromium-browser.desktop";
      "x-scheme-handler/unknown" = "chromium-browser.desktop";
    };
  };
}
