{ config, lib, pkgs, ... }:

{
  # Steam gaming platform
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };
}