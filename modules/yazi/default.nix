{ config, lib, pkgs, username, ... }:

let
  cfg = config.myConfig.yazi;
in
{
  options.myConfig.yazi = {
    enable = lib.mkEnableOption "Yazi file manager";
  };

  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============
    # (None needed - yazi is installed via home-manager)

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = {
      programs.yazi = {
        enable = true;
        settings = {
          opener = {
            edit = [
              { run = "nvim \"$@\""; block = true; for = "unix"; }
            ];
          };
        };
      };
    };
  };
}
