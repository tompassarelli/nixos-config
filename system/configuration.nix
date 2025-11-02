# Edit this configuration file to define what should be installed on your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  imports = [
    # Hardware configuration
    ./hardware-configuration.nix
    
    # Core system modules
    ./modules/boot.nix
    ./modules/desktop.nix
    ./modules/kanata.nix
    ./modules/users.nix
    ./modules/networking.nix
    ./modules/styling.nix
    ./modules/timezone.nix
    ./modules/nix-settings.nix
    ./modules/ssh.nix
    
    # Development and tools
    ./modules/rust.nix
    ./modules/development.nix
    ./modules/utilities.nix
    
    # Applications
    ./modules/firefox.nix
    ./modules/fish.nix
    ./modules/steam.nix
    ./modules/neovim.nix
    ./modules/productivity.nix
    ./modules/creative.nix
    ./modules/media.nix
    ./modules/password.nix
    ./modules/mail.nix
    ./modules/rofi-wayland.nix
    ./modules/waybar.nix
    ./modules/walker.nix
    
    # Hardware-specific (comment out if not using Framework)
    ./modules/framework.nix
  ];

  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  system.stateVersion = "25.05"; # READ THE COMMENT ABOVE
}
