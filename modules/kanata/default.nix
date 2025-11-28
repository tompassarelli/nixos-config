{ lib, ... }:
{
  options.myConfig.kanata = {
    enable = lib.mkEnableOption "Kanata keyboard remapping";
    capsLockEscCtrl = lib.mkEnableOption "Caps Lock as Tap=Esc, Hold=Ctrl";
    leftAltAsSuper = lib.mkEnableOption "Left Alt becomes Super/Meta key";
    wideMod = lib.mkEnableOption "QWERTY Wide Mod - shift right hand keys over by one for better ergonomics";
    spacebarAsMeh = lib.mkEnableOption "Spacebar as Tap=Space, Hold=Meh (Ctrl+Shift+Alt)";
  };

  imports = [
    ./kanata.nix
  ];
}
