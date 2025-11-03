{ config, lib, pkgs, username, ... }:
{
  config = lib.mkIf config.myConfig.utilities.tealdeer.enable {
    # Install tealdeer
    environment.systemPackages = with pkgs; [
      tealdeer
    ];

    home-manager.users.${username} = { config, ... }: {
      # Tealdeer (tldr) configuration
      xdg.configFile."tealdeer/config.toml".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/dotfiles/tealdeer/config.toml";
    };
  };
}
