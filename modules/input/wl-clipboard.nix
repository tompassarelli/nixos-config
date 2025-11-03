{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.myConfig.input.enable {
    environment.systemPackages = with pkgs; [
      wl-clipboard  # clipboard utilities for Wayland
    ];
  };
}
