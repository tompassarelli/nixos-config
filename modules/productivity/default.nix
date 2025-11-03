{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.productivity;
in
{
  options.myConfig.productivity = {
    enable = lib.mkEnableOption "personal productivity applications";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian             # link notes
      todoist-electron     # do things
      pomodoro-gtk         # pomodoro timer
    ];
  };
}