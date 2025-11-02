{ config, lib, pkgs, ... }:

{
  # Creative tools and content creation
  environment.systemPackages = with pkgs; [
    godot_4              # game engine and visual editor
    blender              # release your inner sculpter
    gimp                 # image editing for slaves
    obs-studio           # screen recording/streaming
  ];
}