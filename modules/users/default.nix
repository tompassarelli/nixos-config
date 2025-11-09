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
      extraGroups = [ "wheel" "networkmanager" "plugdev" ]; # Enable 'sudo' for the user
    };

    # Sudo configuration - extend timeout to 30 minutes
    security.sudo.extraConfig = ''
      Defaults timestamp_timeout=30
    '';

    # Create user directories on boot
    systemd.tmpfiles.rules = [
      "d /home/${username}/Documents 0755 ${username} users -"
      "d /home/${username}/Pictures/Screenshots 0755 ${username} users -"
    ];
  };
}
