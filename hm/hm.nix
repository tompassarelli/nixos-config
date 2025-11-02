{ config, pkgs, inputs, username, chosenTheme, ... }:

{
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  imports = [
    # Modules (compositions/abstractions)
    ./modules/anyrun-flake.nix
    ./modules/dotfiles.nix
    ./modules/wayland-services.nix
    ./modules/shell.nix
    ./modules/terminal.nix
    
    # Packages (single-purpose configs)
    ./packages/git.nix
    ./packages/gtk.nix
    ./packages/yazi.nix
    ./packages/mako.nix
  ];
}
