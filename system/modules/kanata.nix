{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.kanata;
in
{
  options.myConfig.kanata = {
    enable = lib.mkEnableOption "Kanata keyboard remapping";
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
      config = ''
        ;; Define aliases
        (defalias
          escctrl (tap-hold-press 200 200 esc lctl)
        )

        ;; Source layer 
        (defsrc caps lalt)

        ;; Base layer
        (deflayer base
          @escctrl lmet
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