{ config, pkgs, ... }:

{
  # Git configuration
  # Requires home-manager for programs.git
  
  programs.git = {
    enable = true;
    userName = "tompassarelli";
    userEmail = "tom.passarelli@protonmail.com";
    delta = {
      enable = true;
      options = {
        navigate = true;
        color-only = true;
        #syntax-theme = "DarkNeon"; # handled by stylix?
      };
    };
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };
}
