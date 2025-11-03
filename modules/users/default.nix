{ config, lib, pkgs, username, ... }:

let
  cfg = config.myConfig.users;
in
{
  options.myConfig.users = {
    enable = lib.mkEnableOption "user account management";
  };

  config = lib.mkIf cfg.enable {
    # Define user account
    users.users.${username} = {
      shell = pkgs.fish;
      isNormalUser = true;
      home = "/home/${username}";
      extraGroups = [ "wheel" "networkmanager" ]; # Enable 'sudo' for the user
    };

    # Create user directories on boot
    systemd.tmpfiles.rules = [
      "d /home/${username}/Pictures/Screenshots 0755 ${username} users -"
    ];
  };
}
