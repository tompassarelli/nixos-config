{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/home/anyrun-flake.nix
    ./modules/home/dotfiles.nix
    ./modules/home/wayland-services.nix
    ./modules/home/shell.nix
    ./modules/home/terminal.nix
    ./modules/home/git.nix
    ./modules/home/gtk.nix
    ./modules/home/yazi.nix
    ./modules/home/mako.nix
  ];
}
