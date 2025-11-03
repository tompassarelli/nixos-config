{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.ssh;
in
{
  # PART 1: Define what users can configure
  options.myConfig.ssh = {
    enable = lib.mkEnableOption "SSH server";
  };

  # PART 2: Use that configuration
  config = lib.mkIf cfg.enable {
    # OpenSSH daemon configuration
    services.openssh.enable = true;
  };
}
