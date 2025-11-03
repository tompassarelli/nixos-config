{ config, lib, pkgs, ... }:
{
  options.myConfig.procs = {
    enable = lib.mkEnableOption "Enable procs (modern ps replacement)";
  };

  config = lib.mkIf config.myConfig.procs.enable {
    environment.systemPackages = with pkgs; [ procs ];
  };
}
