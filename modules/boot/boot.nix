{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.myConfig.boot.enable {
    # Use the systemd-boot EFI boot loader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Use testing kernel (6.18-rc) for mt7925e WiFi fixes
    # The mt7925 driver has deadlock bugs in MLO code causing system hangs
    boot.kernelPackages = pkgs.linuxPackages_testing;

    # Kernel modules for hardware support
    boot.kernelModules = [ "uinput" ];  # Load uinput module early for kanata
  };
}
