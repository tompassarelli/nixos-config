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
    };

    # Automatic garbage collection
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # TODO: Store optimization (disabled for now - plenty of space)
    # Uncomment to enable automatic hard-linking of duplicate files in /nix/store
    # First run can take 30min-2hrs. Can save 2-10GB typically.
    # Manual run: nix-store --optimise
    # nix.optimise = {
    #   automatic = true;
    #   dates = [ "monthly" ];
    # };

    # Limit number of boot generations (prevents /boot from filling up)
    boot.loader.systemd-boot.configurationLimit = 10;
  };
}