# Edit this configuration file to define what should be installed on your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  # Module configuration flags
  myConfig = {
    # Core system modules
    boot.enable = true;
    desktop.enable = true;
    kanata.enable = true;
    users.enable = true;
    networking.enable = true;
    styling.enable = true;
    timezone.enable = true;
    nix-settings.enable = true;
    ssh.enable = true;

    # Development and tools
    rust.enable = true;
    development.enable = true;
    utilities.enable = true;

    # Applications
    firefox.enable = true;
    fish.enable = true;
    steam.enable = true;
    neovim.enable = true;
    productivity.enable = true;
    creative.enable = true;
    media.enable = true;
    password.enable = true;
    mail.enable = true;
    rofi-wayland.enable = true;
    waybar.enable = true;
    walker.enable = true;

    # Hardware-specific (set to false if not using Framework)
    framework.enable = true;
  };

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
