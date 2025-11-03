{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.password;
in
{
  options.myConfig.password = {
    enable = lib.mkEnableOption "password management tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bitwarden            # password manager
    ];
  };
}
