{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.creative;
in
{
  options.myConfig.creative = {
    enable = lib.mkEnableOption "creative tools and content creation";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      godot_4              # game engine and visual editor
      blender              # release your inner sculpter
      gimp                 # image editing for slaves
      obs-studio           # screen recording/streaming
      eyedropper           # modern wayland color picker
    ];
  };
}
