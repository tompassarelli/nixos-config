{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.myConfig.input.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl  # control screen brightness
    ];
  };
}
