{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.boot;
in
{
  options.myConfig.boot = {
    enable = lib.mkEnableOption "boot configuration";
  };

  config = lib.mkIf cfg.enable {
    # Use the systemd-boot EFI boot loader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Use latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Kernel modules for hardware support
    boot.kernelModules = [ "uinput" ];  # Load uinput module early for kanata
  };
}