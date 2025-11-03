{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.myConfig.niri.enable {
    environment.systemPackages = with pkgs; [
      xwayland-satellite  # required as of 2025 for some apps like bitwarden
    ];
  };
}
