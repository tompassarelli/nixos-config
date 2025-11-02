{ config, pkgs, ... }:

{
  # Yazi file manager configuration
  # Requires home-manager for programs.yazi
  
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
}