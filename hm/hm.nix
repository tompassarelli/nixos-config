{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  # Home-manager module configuration flags
  myConfig = {
    anyrun.enable = true;
    dotfiles.enable = true;
    wayland-services.enable = true;
    shell.enable = true;
    terminal.enable = true;
    git.enable = true;
    gtk.enable = true;
    yazi.enable = true;
    mako.enable = true;
  };

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
