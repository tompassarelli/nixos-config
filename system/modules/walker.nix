{ config, lib, pkgs, ... }:

{
  # Walker modern wayland app launcher
  environment.systemPackages = with pkgs; [
    walker               # modern wayland app launcher
  ];
}