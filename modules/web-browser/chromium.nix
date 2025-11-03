{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.myConfig.web-browser.chromium.enable {
    # Install ungoogled-chromium
    environment.systemPackages = with pkgs; [
      ungoogled-chromium
    ];

    # Set as default browser if specified
    xdg.mime.defaultApplications = lib.mkIf (config.myConfig.web-browser.default == "chromium") {
      "text/html" = "chromium-browser.desktop";
      "x-scheme-handler/http" = "chromium-browser.desktop";
      "x-scheme-handler/https" = "chromium-browser.desktop";
      "x-scheme-handler/about" = "chromium-browser.desktop";
      "x-scheme-handler/unknown" = "chromium-browser.desktop";
    };
  };
}
