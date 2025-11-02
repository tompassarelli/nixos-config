{ config, lib, pkgs, ... }:

{
  # Framework Computer specific tools
  # Comment/remove this section if not using a Framework Computer
  environment.systemPackages = with pkgs; [
    framework-tool       # swiss army knife
    fwupd                # update drivers/bios
  ];
}