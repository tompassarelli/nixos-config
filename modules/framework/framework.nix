{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.framework;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      framework-tool       # swiss army knife
      fwupd                # update drivers/bios
    ];

    # MT7925e WiFi stability fixes
    # - disable_clc: Disables Country Location Code auto-detection (6GHz issues)
    # - disable_aspm: Disables PCI power management (prevents race conditions during roaming)
    boot.extraModprobeConfig = ''
      options mt7925_common disable_clc=1
      options mt7925e disable_aspm=1
    '';
  };
}
