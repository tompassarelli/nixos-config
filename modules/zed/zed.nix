{ config, lib, pkgs, ... }:
let
  username = config.myConfig.users.username;
in
{
  config = lib.mkIf config.myConfig.zed.enable {
    environment.systemPackages = with pkgs; [
      unstable.zed-editor
    ];

    home-manager.users.${username} = { config, ... }: {
      home.file.".config/zed".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/dotfiles/zed";
    };
  };
}
