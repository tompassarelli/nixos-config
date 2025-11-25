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
        # Always define full keyboard for layer switching (ISO layout)
        srcKeys = ''
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]
          caps a    s    d    f    g    h    j    k    l    ;    '    \    ret
          lsft 102d z    x    c    v    b    n    m    ,    .    /    rsft
          lctl lalt lmet           spc            rmet ralt cmp  rctl
        '';

        # Base layer keys (QWERTY OR wideMod)
        baseKeys = if cfg.wideMod then ''
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    [    y    u    i    o    p    \
          ${if cfg.capsLockEscCtrl then "@escctrl" else "caps"} a    s    d    f    g    ]    h    j    k    l    ;    '    ret
          lsft @slashshift z x    c    v    b    /    n    m    ,    .    rsft
          lctl ${if cfg.leftAltAsSuper then "lmet" else "lalt"} ${if cfg.leftAltAsSuper then "lalt" else "lmet"}      @spacenum     @enteralt ralt cmp  @topyceia
        ''
        else ''
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]
          ${if cfg.capsLockEscCtrl then "@escctrl" else "caps"} a    s    d    f    g    h    j    k    l    ;    '    \    ret
          lsft 102d z    x    c    v    b    n    m    ,    .    /    rsft
          lctl ${if cfg.leftAltAsSuper then "lmet" else "lalt"} ${if cfg.leftAltAsSuper then "lalt" else "lmet"}      @spacenum     rmet ralt cmp  @topyceia
        '';

        # Pyciea layer keys
        pycieaKeys = ''
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  b    l    d    w    j    [    '    f    o    u    q    ;
          ${if cfg.capsLockEscCtrl then "@escctrl" else "caps"} n    r    t    s    g    ]    y    h    a    e    i    @commactrl    ret
          lsft @zshift    x    m    c    v    -    \    k    p    .    /    rsft
          lctl ${if cfg.leftAltAsSuper then "lmet" else "lalt"} ${if cfg.leftAltAsSuper then "lalt" else "lmet"}      @spacenum     rmet ralt cmp  @tobase
        '';
      in ''
        ;; Define aliases
        ${lib.optionalString cfg.capsLockEscCtrl "(defalias escctrl (tap-hold-press 200 200 esc lctl))"}
        ${lib.optionalString cfg.spacebarAsMeh "(defalias mehtap (tap-hold-press 200 200 spc (multi lctl lsft lalt)))"}
        (defalias slashshift (tap-hold-press 200 200 / lsft))
        (defalias zshift (tap-hold-press 200 200 z lsft))
        (defalias enteralt (tap-hold-press 200 200 ret ralt))
        (defalias commactrl (tap-hold-press 200 200 , lctl))
        (defalias apostrophenum (tap-hold-press 200 200 ' (layer-while-held numbers)))
        (defalias spacenum (tap-hold-release 200 200 spc (layer-while-held numbers)))
        (defalias topyceia (tap-dance 300 (rctl (layer-switch pyciea))))
        (defalias tobase (tap-dance 300 (rctl (layer-switch base))))

        ;; Source layer
        (defsrc ${srcKeys})

        ;; Base layer
        (deflayer base ${baseKeys})

        ;; Pyciea layer
        (deflayer pyciea ${pycieaKeys})

        ;; Numbers layer - qwert=12345, uiop[=67890, jkl;=arrows, m,.=home+-end
        (deflayer numbers
          _    _    _    _    _    _    _    _    _    _    _    _    _    _
          _    1    2    3    4    5    _    6    7    8    9    0    _
          _    _    _    _    _    _    _    left down up   rght _    _    _
          _    _    _    _    _    _    _    _    home +    -    end  _
          _    _    _              _              _    _    _    _
        )
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
