{ config, pkgs, ... }:

{
  imports = [
    ./modules/home/shell.nix
    ./modules/home/terminal.nix
    ./modules/home/git.nix
    ./modules/home/dotfiles.nix
    ./modules/home/gtk.nix
    ./modules/home/yazi.nix
  ];

  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;
}
