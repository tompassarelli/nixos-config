{ config, lib, pkgs, ... }:

{
  # Personal productivity applications
  environment.systemPackages = with pkgs; [
    obsidian             # link notes
    todoist-electron     # do things
  ];
}