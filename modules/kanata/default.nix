{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.kanata;
in
{
  options.myConfig.kanata = {
    enable = lib.mkEnableOption "Kanata keyboard remapping";
    capsLockEscCtrl = lib.mkEnableOption "Caps Lock as Tap=Esc, Hold=Ctrl";
    leftAltAsSuper = lib.mkEnableOption "Left Alt becomes Super/Meta key";
    wideMod = lib.mkEnableOption "QWERTY Wide Mod - shift right hand keys over by one for better ergonomics";
    spacebarAsMeh = lib.mkEnableOption "Spacebar as Tap=Space, Hold=Meh (Ctrl+Shift+Alt)";
  };

  config = lib.mkIf cfg.enable {
    # Hardware support for kanata
    hardware.uinput.enable = true;     # Required for kanata to access uinput
  
  # Proper udev rules for uinput access
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';
  users.groups.uinput = {};
  
  # Create dedicated kanata user with proper permissions
  users.users.kanata = {
    isSystemUser = true;
    group = "kanata";
    extraGroups = [ "input" "uinput" ];
  };
  users.groups.kanata = {};

  # Kanata service configuration
  services.kanata = {
    enable = true;
    keyboards.main = {
      devices = [ "/dev/input/event0" ];  # AT Translated Set 2 keyboard
      extraDefCfg = "process-unmapped-keys yes"; # req for tap-hold-press, or need a set of explicit passthrough keys 
      config = let
        # Build lists of keys based on enabled options
        srcKeys = lib.concatStringsSep " " (
          (lib.optional cfg.capsLockEscCtrl "caps") ++
          (lib.optional cfg.leftAltAsSuper "lalt") ++
          (lib.optional (cfg.spacebarAsMeh && !cfg.wideMod) "spc") ++
          (lib.optionals cfg.wideMod [
            "grv" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "-" "=" "bspc"
            "tab" "q" "w" "e" "r" "t" "y" "u" "i" "o" "p" "[" "]" "ret"
            "a" "s" "d" "f" "g" "h" "j" "k" "l" ";" "'" "\\"
            "lsft" "102d" "z" "x" "c" "v" "b" "n" "m" "," "." "/" "rsft"
            "lctl" "lmet" "spc" "ralt" "rmet" "cmp" "rctl"
          ])
        );

        baseKeys = lib.concatStringsSep " " (
          (lib.optional cfg.capsLockEscCtrl "@escctrl") ++
          (lib.optional cfg.leftAltAsSuper "lmet") ++
          (lib.optional (cfg.spacebarAsMeh && !cfg.wideMod) "@mehtap") ++
          (lib.optionals cfg.wideMod [
            "grv" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "-" "=" "bspc"
            "tab" "q" "w" "e" "r" "t" "[" "y" "u" "i" "o" "p" "\\" "ret"
            "a" "s" "d" "f" "g" "]" "h" "j" "k" "l" ";" "'"
            "lsft" "@slashshift" "z" "x" "c" "v" "b" "/" "n" "m" "," "." "rsft"
            "lctl" "lmet" (if cfg.spacebarAsMeh then "@mehtap" else "spc") "@enteralt" "rmet" "cmp" "rctl"
          ])
        );
      in ''
        ;; Define aliases
        ${lib.optionalString cfg.capsLockEscCtrl "(defalias escctrl (tap-hold-press 200 200 esc lctl))"}
        ${lib.optionalString cfg.spacebarAsMeh "(defalias mehtap (tap-hold-press 200 200 spc (multi lctl lsft lalt)))"}
        (defalias slashshift (one-shot-press 2000 lsft))
        (defalias enteralt (tap-hold-press 200 200 ret ralt))

        ;; Source layer
        (defsrc ${srcKeys})

        ;; Base layer
        (deflayer base ${baseKeys})
      '';
    };
  };

    # Use dedicated user instead of DynamicUser (better security than root)
    systemd.services.kanata-main.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "kanata";
    };
  };
}
