{ config, lib, pkgs, username, ... }:
{
  options.myConfig.tealdeer = {
    enable = lib.mkEnableOption "Enable tealdeer (tldr client)";
  };

  config = lib.mkIf config.myConfig.tealdeer.enable {
    environment.systemPackages = with pkgs; [ tealdeer ];

    home-manager.users.${username} = { config, ... }: {
      xdg.configFile."tealdeer/config.toml".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/dotfiles/tealdeer/config.toml";
    };
  };
}
