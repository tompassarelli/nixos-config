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

    # Disable CLC (Country Location Code) auto-detection
    # Helps with mt7925e stability issues on 6GHz band
    boot.extraModprobeConfig = ''
      options mt7925_common disable_clc=1
    '';
  };
}
