{ config, pkgs, inputs, username, chosenTheme, ... }:

{
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  imports = [
    # All home-manager modules
    ./modules/anyrun-flake.nix
    ./modules/dotfiles.nix
    ./modules/wayland-services.nix
    ./modules/shell.nix
    ./modules/terminal.nix
    ./modules/git.nix
    ./modules/gtk.nix
    ./modules/yazi.nix
    ./modules/mako.nix
  ];
}
