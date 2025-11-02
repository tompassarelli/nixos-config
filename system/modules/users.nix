{ config, lib, pkgs, username, ... }:

{
  # User account management
  
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
}
