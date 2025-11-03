{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.myConfig.niri.enable {
    environment.systemPackages = with pkgs; [
      xwayland-satellite  # required for some apps like 2025 bitwarden
    ];
  };
}
