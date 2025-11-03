{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.framework;
in
{
  options.myConfig.framework = {
    enable = lib.mkEnableOption "Framework Computer specific tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      framework-tool       # swiss army knife
      fwupd                # update drivers/bios
    ];
  };
}
