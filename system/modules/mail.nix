{ config, lib, pkgs, ... }:

{
  # Email applications
  environment.systemPackages = with pkgs; [
    protonmail-desktop   # encrypted mail
  ];
}