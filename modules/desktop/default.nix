{ lib, ... }:
{
  options.myConfig.desktop = {
    enable = lib.mkEnableOption "Enable desktop environment configuration";

    niri.enable = lib.mkEnableOption "Enable niri compositor";
    xdg-portal.enable = lib.mkEnableOption "Enable XDG Desktop Portal";
    fonts.enable = lib.mkEnableOption "Enable font configuration";
    pipewire.enable = lib.mkEnableOption "Enable PipeWire audio";
    libinput.enable = lib.mkEnableOption "Enable touchpad support (libinput)";
    upower.enable = lib.mkEnableOption "Enable power monitoring (upower)";
    security.enable = lib.mkEnableOption "Enable security and authentication (polkit, keyring)";
  };

  imports = [
    ./niri.nix
    ./xdg-portal.nix
    ./fonts.nix
    ./pipewire.nix
    ./libinput.nix
    ./upower.nix
    ./security.nix
  ];
}
