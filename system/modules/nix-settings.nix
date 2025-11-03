{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.nix-settings;
in
{
  options.myConfig.nix-settings = {
    enable = lib.mkEnableOption "Nix configuration and package settings";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      builders-use-substitutes = true;
      extra-substituters = [
        "https://anyrun.cachix.org"
      ];
      extra-trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
    };
  };
}