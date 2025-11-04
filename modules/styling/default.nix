{ config, lib, pkgs, chosenTheme, username, ... }:

let
  cfg = config.myConfig.styling;
in
{
  options.myConfig.styling = {
    enable = lib.mkEnableOption "system-wide theming and styling";
  };

  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${chosenTheme}.yaml";
    };

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = { config, ... }: {
      # Stylix Firefox target configuration
      stylix.targets.firefox = {
        profileNames = [ username ];
        colorTheme.enable = true;
      };

      # Themes directory (wallpapers and other theme assets)
      xdg.configFile."themes".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/dotfiles/themes";
    };
  };
}
