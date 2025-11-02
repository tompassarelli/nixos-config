{ config, lib, pkgs, ... }:

{
  # OpenSSH daemon configuration
  services.openssh.enable = true;
}