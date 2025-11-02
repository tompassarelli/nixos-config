{ config, lib, pkgs, ... }:

{
  # Password management
  environment.systemPackages = with pkgs; [
    bitwarden            # password manager
  ];
}