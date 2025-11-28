{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.myConfig.boot.enable {
    # Use the systemd-boot EFI boot loader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Use latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Kernel modules for hardware support
    boot.kernelModules = [ "uinput" ];  # Load uinput module early for kanata
  };
}
