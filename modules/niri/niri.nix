{ config, lib, pkgs, ... }:
let
  username = config.myConfig.users.username;
in
{
  config = lib.mkIf config.myConfig.niri.enable {
    # Enable niri compositor at system level
    programs.niri.enable = true;

    home-manager.users.${username} = { config, ... }: {
      # Niri configuration file
      xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/dotfiles/niri/config.kdl";
    };
  };
}
