{ config, lib, pkgs, username, inputs, ... }:
{
  config = lib.mkIf config.myConfig.web-browser.firefox.enable {
    programs.firefox.enable = true;

    # Set as default browser if specified
    xdg.mime.defaultApplications = lib.mkIf (config.myConfig.web-browser.default == "firefox") {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };

    home-manager.users.${username} = { config, ... }: {
      programs.firefox = {
        enable = true;
        profiles.${username} = {
          settings = {
            # Enable custom stylesheets
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

            # Enable browser toolbox
            "devtools.chrome.enabled" = true;
            "devtools.debugger.remote-enabled" = true;
          };

          # Extensions
          extensions = {
            # Allow Stylix to manage extension settings
            force = true;

            # Install Sidebery for vertical tabs
            packages = [
              inputs.nur.legacyPackages.${pkgs.system}.repos.rycee.firefox-addons.sidebery
            ];
          };
        };
      };

      # Symlink custom Firefox chrome directory
      home.file.".mozilla/firefox/${username}/chrome".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/dotfiles/firefox/chrome";
    };
  };
}
