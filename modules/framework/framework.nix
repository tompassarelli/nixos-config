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
  };
}
